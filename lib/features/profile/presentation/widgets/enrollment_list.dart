import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

/// "Kayıtlı Sınavlar" (web profile "Kayıtlı Sınavlarım"): the active exam is
/// marked, others can be switched to or removed. The last exam can't be
/// removed; progress is kept when an exam is removed.
class EnrollmentList extends ConsumerStatefulWidget {
  const EnrollmentList({required this.enrollments, super.key});

  final List<EnrollmentModel> enrollments;

  @override
  ConsumerState<EnrollmentList> createState() => _EnrollmentListState();
}

class _EnrollmentListState extends ConsumerState<EnrollmentList> {
  /// The exam a switch / remove request is running for.
  String? _busyId;

  void _showError(ApiException e, String offlineMessage) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.isNetworkError ? offlineMessage : e.message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _run(String examTypeId, Future<void> Function() action) async {
    setState(() => _busyId = examTypeId);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _switch(EnrollmentModel e) => _run(e.examTypeId, () async {
    try {
      await ref.read(authStateProvider.notifier).setActiveExam(e.examTypeId);
    } on ApiException catch (err) {
      _showError(err, 'Sınav değiştirmek için internet bağlantısı gerekli.');
    }
  });

  Future<void> _remove(EnrollmentModel e) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sınavı Kaldır'),
        content: Text(
          '${e.examTypeName} kayıtlı sınavlarından kaldırılsın mı? '
          'İlerlemen korunur, istediğin zaman yeniden ekleyebilirsin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _run(e.examTypeId, () async {
      try {
        final newActive = await ref
            .read(userRepositoryProvider)
            .removeEnrollment(e.examTypeId);
        if (newActive != null) {
          ref.read(authStateProvider.notifier).activeExamChanged(newActive);
        }
        ref.invalidate(enrollmentsProvider);
      } on ApiException catch (err) {
        _showError(err, 'Sınav kaldırmak için internet bağlantısı gerekli.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(
      authStateProvider.select((s) => s.valueOrNull?.activeExamId),
    );
    final enrollments = widget.enrollments;
    final canRemove = enrollments.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kayıtlı Sınavlar',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton.icon(
              onPressed: () => context.push(Routes.examSelect),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Sınav Ekle'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final e in enrollments)
          _EnrollmentTile(
            enrollment: e,
            isActive: e.examTypeId == activeId,
            isBusy: _busyId == e.examTypeId,
            // One request at a time.
            enabled: _busyId == null,
            canRemove: canRemove,
            onSwitch: () => _switch(e),
            onRemove: () => _remove(e),
          ),
      ],
    );
  }
}

class _EnrollmentTile extends StatelessWidget {
  const _EnrollmentTile({
    required this.enrollment,
    required this.isActive,
    required this.isBusy,
    required this.enabled,
    required this.canRemove,
    required this.onSwitch,
    required this.onRemove,
  });

  final EnrollmentModel enrollment;
  final bool isActive;
  final bool isBusy;
  final bool enabled;
  final bool canRemove;
  final VoidCallback onSwitch;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.grey200,
          width: isActive ? 2 : 1,
        ),
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.grey50,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollment.examGroupName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enrollment.examTypeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),
          ),
          if (isBusy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successSurface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Aktif',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            )
          else
            OutlinedButton(
              onPressed: enabled ? onSwitch : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Geç'),
            ),
          IconButton(
            tooltip: canRemove
                ? 'Sınavı kaldır'
                : 'Son kayıtlı sınavını kaldıramazsın',
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.grey400,
            onPressed: enabled && canRemove && !isBusy ? onRemove : null,
          ),
        ],
      ),
    );
  }
}
