import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

class RoadmapNode extends StatelessWidget {
  const RoadmapNode({
    required this.topic,
    required this.onTap,
    required this.alignment,
    super.key,
  });

  final TopicModel topic;
  final VoidCallback onTap;
  final double alignment; // -1 to 1 for zigzag

  @override
  Widget build(BuildContext context) {
    final isLocked = topic.progress?.isUnlocked != true;
    final crownLevel = topic.progress?.crownLevel ?? 0;
    final isActive = !isLocked && crownLevel < topic.maxCrownLevel;
    final color = _getNodeColor();
    const size = 64.0;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        alignment: Alignment(alignment, 0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isActive)
                  Container(
                    width: size + 12,
                    height: size + 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.2),
                    ),
                  ),
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked ? AppColors.grey300 : color,
                    boxShadow: isLocked
                        ? null
                        : [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Icon(
                    _getNodeIcon(),
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                if (crownLevel > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$crownLevel',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isLocked)
                  const Icon(Icons.lock, color: AppColors.grey500, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              child: Text(
                topic.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isLocked ? AppColors.grey400 : AppColors.grey700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNodeColor() {
    if (topic.progress?.isUnlocked == false) return AppColors.grey300;
    if (topic.steps.any((s) => s.type == StepType.reward)) return AppColors.accent;
    return AppColors.primary;
  }

  IconData _getNodeIcon() {
    if (topic.progress?.isUnlocked == false) return Icons.lock;
    if (topic.steps.any((s) => s.type == StepType.reward)) return Icons.card_giftcard;
    return Icons.menu_book;
  }
}
