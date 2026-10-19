import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/onboarding/data/exam_groups_repository.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

/// Exam selection, mirroring the web client's `pages/welcome.vue`.
/// A visitor becomes a guest with the chosen exam and goes straight to the
/// lesson map (docs 10); a logged-in user adds the exam to their enrollments
/// and continues with it as the active exam. Picking an exam they are
/// already enrolled in just switches to it.
class ExamSelectScreen extends ConsumerStatefulWidget {
  const ExamSelectScreen({super.key});

  @override
  ConsumerState<ExamSelectScreen> createState() => _ExamSelectScreenState();
}

class _ExamSelectScreenState extends ConsumerState<ExamSelectScreen> {
  ExamGroupModel? _selectedGroup;
  bool _saving = false;

  /// Exams a logged-in user is already enrolled in.
  Set<String> get _enrolledIds => {
    ...?ref.read(enrollmentsProvider).valueOrNull?.map((e) => e.examTypeId),
  };

  void _selectGroup(ExamGroupModel group) {
    if (!group.isActive) return;
    // A group with a single type selects it right away (docs 4).
    if (group.examTypes.length == 1) {
      _selectExamType(group, group.examTypes.first);
      return;
    }
    setState(() => _selectedGroup = group);
  }

  Future<void> _selectExamType(ExamGroupModel group, ExamTypeModel type) async {
    final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
    if (!isLoggedIn) {
      ref
          .read(guestProvider.notifier)
          .setExamType(examTypeId: type.id, examGroupId: group.id);
      context.go(Routes.home);
      return;
    }

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (!_enrolledIds.contains(type.id)) {
        try {
          await ref.read(userRepositoryProvider).addEnrollment(type.id);
        } on ApiException catch (e) {
          // 409: already enrolled (e.g. a stale list); just switch to it.
          if (e.statusCode != 409) rethrow;
        }
        ref.invalidate(enrollmentsProvider);
      }
      await ref.read(authStateProvider.notifier).setActiveExam(type.id);
      if (mounted) context.go(Routes.home);
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.isNetworkError
                ? 'Sınav eklemek için internet bağlantısı gerekli.'
                : e.message,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(examGroupsProvider);
    final isLoggedIn = ref.watch(authStateProvider).valueOrNull != null;
    // Watched so the "Kayıtlı" badges are current.
    ref.watch(enrollmentsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.welcome),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const Text(
              'pracby',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hangi sınava hazırlanıyorsun?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 24),
            if (_saving)
              const PbLoading()
            else
              groupsAsync.when(
                loading: () => const PbLoading(message: 'Yükleniyor...'),
                error: (e, _) => Center(child: Text('$e')),
                data: (groups) => _selectedGroup == null
                    ? _groupList(groups)
                    : _typeList(_selectedGroup!),
              ),
            if (!isLoggedIn) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Zaten hesabın var mı?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey400,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(Routes.login),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _groupList(List<ExamGroupModel> groups) {
    return Column(
      children: [
        for (final group in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              title: group.name,
              subtitle: group.description,
              // Inactive groups are shown as "Çok Yakında" (docs 4).
              badge: group.isActive ? null : 'ÇOK YAKINDA',
              onTap: group.isActive ? () => _selectGroup(group) : null,
            ),
          ),
      ],
    );
  }

  Widget _typeList(ExamGroupModel group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => setState(() => _selectedGroup = null),
          child: const Text(
            '← Geri',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Alt kategori seç:',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.grey400,
            ),
          ),
        ),
        for (final type in group.examTypes)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              title: type.name,
              badge: _enrolledIds.contains(type.id) ? 'KAYITLI' : null,
              onTap: () => _selectExamType(group, type),
            ),
          ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Material(
        color: disabled ? AppColors.grey50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200, width: 2),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey800,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: -8,
                    right: -12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
