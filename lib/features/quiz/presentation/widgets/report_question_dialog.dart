import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';

/// "Soruyu Raporla" modal (docs 9, web quiz page report modal).
/// Pass [guestId] to use the guest endpoint.
Future<void> showReportQuestionDialog(
  BuildContext context, {
  required String questionId,
  String? guestId,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _ReportQuestionDialog(questionId: questionId, guestId: guestId),
  );
}

const _reasons = [
  ('wrong_answer', 'Yanlış cevap işaretlenmiş'),
  ('unclear_question', 'Soru belirsiz / anlaşılmıyor'),
  ('wrong_explanation', 'Açıklama hatalı'),
  ('typo', 'Yazım hatası var'),
  ('missing_image', 'Görsel eksik veya yanlış'),
  ('other', 'Diğer'),
];

class _ReportQuestionDialog extends ConsumerStatefulWidget {
  const _ReportQuestionDialog({required this.questionId, this.guestId});

  final String questionId;
  final String? guestId;

  @override
  ConsumerState<_ReportQuestionDialog> createState() =>
      _ReportQuestionDialogState();
}

class _ReportQuestionDialogState extends ConsumerState<_ReportQuestionDialog> {
  final _description = TextEditingController();
  String? _reason;
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() {
      _submitting = true;
      _error = null;
      _success = null;
    });
    try {
      await ref.read(quizRepositoryProvider).reportQuestion(
            questionId: widget.questionId,
            reason: reason,
            description: _description.text,
            guestId: widget.guestId,
          );
      if (!mounted) return;
      setState(() => _success = 'Rapor gönderildi, teşekkürler!');
      unawaited(
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.of(context).pop();
        }),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _error = switch (e.statusCode) {
          409 => 'Bu soruyu zaten bildirdin.',
          429 => 'Çok fazla bildirim gönderdin, daha sonra tekrar dene.',
          _ => e.statusCode == 0 ? 'Rapor gönderilemedi.' : e.message,
        },
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soruyu Raporla',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final (value, label) in _reasons)
                    RadioListTile<String>(
                      value: value,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 2,
              // Guests are limited to 200 characters, members to 500.
              maxLength: widget.guestId != null ? 200 : 500,
              decoration: const InputDecoration(
                hintText: 'Ek açıklama (isteğe bağlı)...',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _reason == null || _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                    ),
                    child: Text(_submitting ? 'Gönderiliyor...' : 'Gönder'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.grey100,
                      foregroundColor: AppColors.grey500,
                      minimumSize: const Size.fromHeight(42),
                    ),
                    child: const Text('İptal'),
                  ),
                ),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (_success != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _success!,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
