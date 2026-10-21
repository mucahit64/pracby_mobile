import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/onboarding/data/exam_groups_repository.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/profile_ui.dart';

/// The web profile's "Sınavı Kaldır" and "Sınav Ekle" modals.

String _errorText(ApiException e, String offlineMessage) =>
    e.isNetworkError ? offlineMessage : e.message;

/// Asks before removing [examTypeId] and removes it. The request runs in the
/// dialog, which stays open with the error when it fails (web).
Future<void> showRemoveEnrollmentDialog(
  BuildContext context,
  String examTypeId,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _RemoveEnrollmentDialog(examTypeId: examTypeId),
  );
}

class _RemoveEnrollmentDialog extends ConsumerStatefulWidget {
  const _RemoveEnrollmentDialog({required this.examTypeId});

  final String examTypeId;

  @override
  ConsumerState<_RemoveEnrollmentDialog> createState() =>
      _RemoveEnrollmentDialogState();
}

class _RemoveEnrollmentDialogState
    extends ConsumerState<_RemoveEnrollmentDialog> {
  bool _deleting = false;
  String? _error;

  Future<void> _confirm() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      final newActive = await ref
          .read(userRepositoryProvider)
          .removeEnrollment(widget.examTypeId);
      if (newActive != null) {
        ref.read(authStateProvider.notifier).activeExamChanged(newActive);
      }
      ref.invalidate(enrollmentsProvider);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _error = _errorText(
          e,
          'Sınav kaldırmak için internet bağlantısı gerekli.',
        ),
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final close = _deleting ? () {} : () => Navigator.of(context).pop();
    return PopScope(
      canPop: !_deleting,
      child: ProfileDialog(
        onClose: close,
        children: [
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const PbIcon(PbIcons.trash, size: 29),
              ),
              const SizedBox(height: 12),
              const ProfileDialogTitle('Sınavı Kaldır'),
              const SizedBox(height: 12),
              const Text(
                'İlerlemeniz korunur ve istediğiniz zaman yeniden '
                'katılabilirsiniz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.625,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          if (_error != null) ProfileDialogError(_error!),
          Row(
            children: [
              Expanded(
                child: ProfileOutlineButton(
                  label: 'Vazgeç',
                  onPressed: _deleting ? null : close,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ProfilePressButton(
                  label: _deleting ? 'Kaldırılıyor…' : 'Kaldır',
                  color: AppColors.error,
                  // border-negative/70 over the white page.
                  edgeColor: Color.alphaBlend(
                    AppColors.error.withValues(alpha: 0.7),
                    Colors.white,
                  ),
                  onPressed: _deleting ? null : _confirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Two steps: pick an exam group, then one of its exams the user isn't
/// enrolled in yet. Adding doesn't change the active exam.
Future<void> showEnrollDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _EnrollDialog(),
  );
}

class _EnrollDialog extends ConsumerStatefulWidget {
  const _EnrollDialog();

  @override
  ConsumerState<_EnrollDialog> createState() => _EnrollDialogState();
}

class _EnrollDialogState extends ConsumerState<_EnrollDialog> {
  int _step = 1;
  ExamGroupModel? _group;
  String? _typeId;
  bool _enrolling = false;
  String? _error;

  List<ExamTypeModel> _availableTypes() {
    final enrolled = {
      ...?ref.read(enrollmentsProvider).valueOrNull?.map((e) => e.examTypeId),
    };
    return [...?_group?.examTypes.where((t) => !enrolled.contains(t.id))];
  }

  Future<void> _submit() async {
    final typeId = _typeId;
    if (typeId == null) return;
    setState(() {
      _enrolling = true;
      _error = null;
    });
    try {
      try {
        await ref.read(userRepositoryProvider).addEnrollment(typeId);
      } on ApiException catch (e) {
        // 409: already enrolled (a stale list) — nothing to add.
        if (e.statusCode != 409) rethrow;
      }
      ref.invalidate(enrollmentsProvider);
      // Only a user without an active exam starts on the new one.
      if (ref.read(authStateProvider).valueOrNull?.activeExamId == null) {
        await ref.read(authStateProvider.notifier).setActiveExam(typeId);
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _error = _errorText(
          e,
          'Sınav eklemek için internet bağlantısı gerekli.',
        ),
      );
    } finally {
      if (mounted) setState(() => _enrolling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(enrollmentsProvider);
    return ProfileDialog(
      maxWidth: 440,
      children: _step == 1 ? _groupStep() : _typeStep(),
    );
  }

  List<Widget> _groupStep() {
    final groupsAsync = ref.watch(examGroupsProvider);
    return [
      const ProfileDialogTitle('Sınav Grubu Seç'),
      if (groupsAsync.isLoading)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Yükleniyor…',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.grey400),
          ),
        )
      else
        _OptionList(
          children: [
            for (final group
                in groupsAsync.valueOrNull ?? const <ExamGroupModel>[])
              _OptionCard(
                title: group.name,
                subtitle: group.description,
                selected: _group?.id == group.id,
                badge: group.isActive ? null : 'Çok Yakında',
                onTap: group.isActive
                    ? () => setState(() {
                        _group = group;
                        _typeId = null;
                      })
                    : null,
              ),
          ],
        ),
      ProfilePressButton(
        label: 'Devam →',
        onPressed: _group == null ? null : () => setState(() => _step = 2),
      ),
    ];
  }

  List<Widget> _typeStep() {
    final types = _availableTypes();
    return [
      const ProfileDialogTitle('Sınav Türü Seç'),
      if (types.isNotEmpty)
        _OptionList(
          children: [
            for (final type in types)
              _OptionCard(
                title: type.name,
                subtitle: type.description,
                selected: _typeId == type.id,
                onTap: () => setState(() => _typeId = type.id),
              ),
          ],
        )
      else
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Bu gruptaki tüm sınavlara zaten kayıtlısın.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey400),
          ),
        ),
      if (_error != null) ProfileDialogError(_error!),
      Row(
        children: [
          Expanded(
            child: ProfileOutlineButton(
              label: '← Geri',
              onPressed: () => setState(() {
                _step = 1;
                _error = null;
              }),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ProfilePressButton(
              label: _enrolling ? 'Ekleniyor…' : 'Sınav Ekle',
              onPressed: _typeId == null || _enrolling ? null : _submit,
            ),
          ),
        ],
      ),
    ];
  }
}

class _OptionList extends StatelessWidget {
  const _OptionList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          children[i],
        ],
      ],
    );
  }
}

/// A group / exam choice (`px-4 py-3 rounded-2xl border-2 bg-gray-50`).
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.grey200,
        width: 2,
      ),
    );
    final description = subtitle;
    return Opacity(
      opacity: onTap == null ? 0.4 : 1,
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.grey50,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      // Keeps the name clear of the badge.
                      padding: EdgeInsets.only(right: badge == null ? 0 : 76),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 16 / 12,
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
                  top: 12,
                  right: 12,
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
                        fontSize: 10.4,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
