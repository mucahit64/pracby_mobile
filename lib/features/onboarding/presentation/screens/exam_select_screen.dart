import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/onboarding/data/exam_groups_repository.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

/// Stores the selected exam type ID for use during registration
final selectedExamTypeIdProvider = StateProvider<String?>((ref) => null);

class ExamSelectScreen extends ConsumerStatefulWidget {
  const ExamSelectScreen({super.key});

  @override
  ConsumerState<ExamSelectScreen> createState() => _ExamSelectScreenState();
}

class _ExamSelectScreenState extends ConsumerState<ExamSelectScreen> {
  String? _selectedExamTypeId;
  String? _expandedGroupId;
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_selectedExamTypeId == null) return;
    final isLoggedIn =
        ref.read(authStateProvider).valueOrNull != null;
    if (isLoggedIn) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(userRepositoryProvider)
            .addEnrollment(_selectedExamTypeId!);
        ref.invalidate(enrollmentsProvider);
        if (mounted) {
          context.canPop() ? context.pop() : context.go(Routes.home);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ref.read(selectedExamTypeIdProvider.notifier).state =
          _selectedExamTypeId;
      context.go(Routes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    final examGroupsAsync = ref.watch(examGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.welcome),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hangi sınava hazırlanıyorsun?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Daha sonra değiştirebilirsin',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey500,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: examGroupsAsync.when(
                  loading: () => const PbLoading(message: 'Yükleniyor...'),
                  error: (e, _) => Center(child: Text('Hata: $e')),
                  data: _buildExamList,
                ),
              ),
              const SizedBox(height: 24),
              PbButton(
                text: _isLoading ? 'Yükleniyor...' : 'Devam Et',
                onPressed: _selectedExamTypeId != null && !_isLoading
                    ? _handleContinue
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamList(List<ExamGroupModel> groups) {
    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = groups[index];
        if (!group.isActive) return const SizedBox.shrink();

        final isExpanded = _expandedGroupId == group.id;
        final hasMultipleTypes = group.examTypes.length > 1;

        if (!hasMultipleTypes && group.examTypes.isNotEmpty) {
          // Single exam type — show directly
          final examType = group.examTypes.first;
          return _buildExamTypeCard(
            name: group.name,
            description: group.description ?? '',
            examTypeId: examType.id,
          );
        }

        // Multiple exam types — expandable group
        return Column(
          children: [
            _buildGroupCard(group, isExpanded: isExpanded),
            if (isExpanded)
              ...group.examTypes
                  .where((t) => t.isActive)
                  .map((type) => Padding(
                        padding: const EdgeInsets.only(left: 24, top: 8),
                        child: _buildExamTypeCard(
                          name: type.name,
                          description: type.description ?? '',
                          examTypeId: type.id,
                        ),
                      )),
          ],
        );
      },
    );
  }

  Widget _buildGroupCard(ExamGroupModel group, {required bool isExpanded}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedGroupId = isExpanded ? null : group.id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? AppColors.primary : AppColors.grey200,
            width: isExpanded ? 2 : 1,
          ),
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isExpanded
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  group.name[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isExpanded ? AppColors.primary : AppColors.grey600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isExpanded ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  if (group.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      group.description!,
                      style: const TextStyle(fontSize: 13, color: AppColors.grey500),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamTypeCard({
    required String name,
    required String description,
    required String examTypeId,
  }) {
    final isSelected = _selectedExamTypeId == examTypeId;

    return GestureDetector(
      onTap: () => setState(() => _selectedExamTypeId = examTypeId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.grey600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13, color: AppColors.grey500),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary)
            else
              const Icon(Icons.circle_outlined, color: AppColors.grey300),
          ],
        ),
      ),
    );
  }
}
