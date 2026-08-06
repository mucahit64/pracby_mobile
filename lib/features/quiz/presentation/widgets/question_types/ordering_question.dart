import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class OrderingQuestion extends StatefulWidget {
  const OrderingQuestion({
    required this.question,
    required this.onAnswer,
    required this.isAnswered,
    super.key,
  });

  final QuestionModel question;
  final void Function(List<int> orderedIndices) onAnswer;
  final bool isAnswered;

  @override
  State<OrderingQuestion> createState() => _OrderingQuestionState();
}

class _OrderingQuestionState extends State<OrderingQuestion> {
  late List<_OrderItem> _items;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  void _initItems() {
    final typeData = widget.question.typeData;
    if (typeData != null && typeData['items'] != null) {
      final items = (typeData['items'] as List<dynamic>)
          .map((e) => OrderingItem.fromJson(e as Map<String, dynamic>))
          .toList();
      // Show items in shuffled order
      _items = List.generate(
        items.length,
        (i) => _OrderItem(originalIndex: i, text: items[i].text),
      );
      _items.shuffle();
    } else {
      _items = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Center(child: Text('Sıralama verisi bulunamadı'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doğru sıraya dizin',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: !widget.isAnswered,
          itemCount: _items.length,
          onReorder: widget.isAnswered ? (_, __) {} : _onReorder,
          itemBuilder: (context, index) {
            final item = _items[index];
            return Container(
              key: ValueKey(item.originalIndex),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200, width: 1.5),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.grey800,
                      ),
                    ),
                  ),
                  if (!widget.isAnswered)
                    const Icon(
                      Icons.drag_handle,
                      color: AppColors.grey400,
                    ),
                ],
              ),
            );
          },
        ),
        if (!widget.isAnswered)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitAnswer,
                child: const Text('Onayla'),
              ),
            ),
          ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  void _submitAnswer() {
    final orderedIndices = _items.map((item) => item.originalIndex).toList();
    widget.onAnswer(orderedIndices);
  }
}

class _OrderItem {
  const _OrderItem({required this.originalIndex, required this.text});

  final int originalIndex;
  final String text;
}
