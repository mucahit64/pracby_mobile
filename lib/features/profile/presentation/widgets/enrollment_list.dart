import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/enrollment_dialogs.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/profile_ui.dart';

/// Web profile "Kayıtlı Sınavlarım" list: the active exam is marked, others
/// can be switched to or removed, and "+ Sınav Ekle" opens the add dialog.
/// The last exam can't be removed; progress is kept when an exam is removed.
class EnrollmentList extends ConsumerStatefulWidget {
  const EnrollmentList({required this.enrollments, super.key});

  final List<EnrollmentModel> enrollments;

  @override
  ConsumerState<EnrollmentList> createState() => _EnrollmentListState();
}

class _EnrollmentListState extends ConsumerState<EnrollmentList> {
  /// The exam a switch request is running for.
  String? _busyId;

  Future<void> _switch(EnrollmentModel e) async {
    setState(() => _busyId = e.examTypeId);
    try {
      await ref.read(authStateProvider.notifier).setActiveExam(e.examTypeId);
    } on ApiException catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.isNetworkError
                  ? 'Sınav değiştirmek için internet bağlantısı gerekli.'
                  : err.message,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(
      authStateProvider.select((s) => s.valueOrNull?.activeExamId),
    );
    final enrollments = widget.enrollments;
    final canRemove = enrollments.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final e in enrollments) ...[
          _EnrollmentTile(
            enrollment: e,
            isActive: e.examTypeId == activeId,
            isBusy: _busyId == e.examTypeId,
            // One request at a time.
            enabled: _busyId == null,
            canRemove: canRemove,
            onSwitch: () => _switch(e),
            onRemove: () => showRemoveEnrollmentDialog(context, e.examTypeId),
          ),
          const SizedBox(height: 10),
        ],
        const _AddButton(),
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
    final removable = enabled && canRemove && !isBusy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.grey200,
          width: 2,
        ),
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trUpper(enrollment.examGroupName),
                  style: const TextStyle(
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: AppColors.grey400,
                  ),
                ),
                Text(
                  enrollment.examTypeName,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w800,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Aktif',
                style: TextStyle(
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            )
          else
            _SwitchButton(onPressed: enabled ? onSwitch : null),
          const SizedBox(width: 8),
          Tooltip(
            message: canRemove
                ? 'Sınavı kaldır'
                : 'Son kayıtlı sınavınızı silemezsiniz',
            child: GestureDetector(
              onTap: removable ? onRemove : null,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: canRemove ? AppColors.grey200 : AppColors.grey100,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: canRemove ? AppColors.grey400 : AppColors.grey300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Geç" (`bg-white text-primary text-xs font-bold px-3 py-1.5 rounded-xl
/// border-2 border-primary`).
class _SwitchButton extends StatelessWidget {
  const _SwitchButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.primary, width: 2),
    );
    return Material(
      color: Colors.white,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: const Padding(
          // px-3 py-1.5 plus the 2px border.
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            'Geç',
            style: TextStyle(
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// "+ Sınav Ekle" (`bg-gray-50 border-2 border-dashed border-gray-300
/// text-gray-400 font-bold text-sm py-3 rounded-2xl`).
class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return DashedBorder(
      color: AppColors.grey300,
      radius: 16,
      child: Material(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => showEnrollDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              '+ Sınav Ekle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w700,
                color: AppColors.grey400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
