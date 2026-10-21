import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

/// Lesson-map nodes, mirroring the web client's `pages/index.vue`
/// (`buildLessonNodes`, node classes and `getNodeShadowColor`) and
/// MOBILE_APP_DOCS.md 6.4.

enum MapNodeType { lesson, chest, boss }

enum MapNodeStatus { completed, active, locked }

/// Topic header / lesson node colors (web `utils/constants.ts` TOPIC_COLORS).
typedef TopicColor = ({Color color, Color shadow});

const topicColors = <TopicColor>[
  (color: Color(0xFF3B82F6), shadow: Color(0xFF1D4ED8)), // blue
  (color: Color(0xFF10B981), shadow: Color(0xFF047857)), // emerald
  (color: Color(0xFFF59E0B), shadow: Color(0xFFB45309)), // amber
  (color: Color(0xFFF43F5E), shadow: Color(0xFFBE123C)), // rose
  (color: Color(0xFF8B5CF6), shadow: Color(0xFF6D28D9)), // violet
  (color: Color(0xFF06B6D4), shadow: Color(0xFF0E7490)), // cyan
  (color: Color(0xFFF97316), shadow: Color(0xFFC2410C)), // orange
  (color: Color(0xFFD946EF), shadow: Color(0xFFA21CAF)), // fuchsia
  (color: Color(0xFF14B8A6), shadow: Color(0xFF0F766E)), // teal
  (color: Color(0xFFEF4444), shadow: Color(0xFFB91C1C)), // red
];

class MapNode {
  const MapNode({
    required this.type,
    required this.status,
    this.step,
    this.bestScore = 0,
  });

  final MapNodeType type;
  final MapNodeStatus status;

  /// Null for the boss node, which the client appends to every topic.
  final StepModel? step;
  final int bestScore;
}

/// Lessons and chests form one sequence: completed steps, then the first
/// unfinished one is active, the rest locked. A boss node closes the topic
/// and is active only when every step is completed.
List<MapNode> buildLessonNodes(
  TopicModel topic, {
  Set<String> openedChests = const {},
}) {
  final nodes = <MapNode>[];
  var foundActive = false;
  for (final step in topic.steps) {
    final completed =
        (step.progress?.isStepCompleted ?? false) ||
        openedChests.contains(step.id);
    final MapNodeStatus status;
    if (completed) {
      status = MapNodeStatus.completed;
    } else if (!foundActive) {
      status = MapNodeStatus.active;
      foundActive = true;
    } else {
      status = MapNodeStatus.locked;
    }
    nodes.add(
      MapNode(
        type: step.type == StepType.reward
            ? MapNodeType.chest
            : MapNodeType.lesson,
        status: status,
        step: step,
        bestScore: step.progress?.bestScore ?? 0,
      ),
    );
  }
  if (topic.steps.isNotEmpty) {
    final allDone = topic.steps.every(
      (s) =>
          (s.progress?.isStepCompleted ?? false) || openedChests.contains(s.id),
    );
    nodes.add(
      MapNode(
        type: MapNodeType.boss,
        status: allDone ? MapNodeStatus.active : MapNodeStatus.locked,
      ),
    );
  }
  return nodes;
}

/// Horizontal zigzag offsets, repeating every 5 nodes (web: 0/40/65/40/0px).
double nodeOffset(int index) => const <double>[0, 40, 65, 40, 0][index % 5];

/// The 70×62 oval button with a solid 8px "3D" shadow.
class MapNodeView extends StatefulWidget {
  const MapNodeView({
    required this.node,
    required this.topicColor,
    required this.onTap,
    super.key,
  });

  final MapNode node;
  final TopicColor topicColor;
  final VoidCallback? onTap;

  @override
  State<MapNodeView> createState() => _MapNodeViewState();
}

class _MapNodeViewState extends State<MapNodeView> {
  bool _pressed = false;

  static const _amber100 = Color(0xFFFEF3C7);

  ({Color background, Color shadow, double opacity}) get _style {
    final n = widget.node;
    final locked = n.status == MapNodeStatus.locked;
    switch (n.type) {
      case MapNodeType.lesson:
        return locked
            ? (
                background: AppColors.grey200,
                shadow: AppColors.grey400,
                opacity: 1,
              )
            : (
                background: widget.topicColor.color,
                shadow: widget.topicColor.shadow,
                opacity: 1,
              );
      case MapNodeType.chest:
        return switch (n.status) {
          MapNodeStatus.active => (
            background: AppColors.warning,
            shadow: const Color(0xFFCC7800),
            opacity: 1,
          ),
          MapNodeStatus.locked => (
            background: _amber100,
            shadow: const Color(0xFFD97706),
            opacity: 0.6,
          ),
          MapNodeStatus.completed => (
            background: _amber100,
            shadow: const Color(0xFFFCD34D),
            opacity: 1,
          ),
        };
      case MapNodeType.boss:
        return locked
            ? (
                background: AppColors.grey200,
                shadow: AppColors.grey400,
                opacity: 1,
              )
            : (
                background: AppColors.error,
                shadow: const Color(0xFFCC2222),
                opacity: 1,
              );
    }
  }

  Widget get _content {
    final n = widget.node;
    if (n.type == MapNodeType.lesson && n.status == MapNodeStatus.completed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${n.bestScore}',
            style: TextStyle(
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'puan',
            style: TextStyle(
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      );
    }
    if (n.type == MapNodeType.chest && n.status == MapNodeStatus.completed) {
      return const SizedBox(
        width: 36,
        height: 36,
        child: CustomPaint(painter: _OpenedGiftPainter()),
      );
    }
    final locked = n.status == MapNodeStatus.locked;
    final icon = switch (n.type) {
      MapNodeType.chest => PbIcons.gift,
      _ when locked => PbIcons.lock,
      MapNodeType.boss => PbIcons.swords,
      MapNodeType.lesson => PbIcons.test,
    };
    return PbIcon(icon, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final n = widget.node;
    final pressed = _pressed && widget.onTap != null;

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 70,
      height: 62,
      transform: Matrix4.translationValues(0, pressed ? 8 : 0, 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: const BorderRadius.all(Radius.elliptical(35, 31)),
        boxShadow: pressed
            ? null
            : [BoxShadow(color: style.shadow, offset: const Offset(0, 8))],
      ),
      child: _content,
    );

    return Opacity(
      opacity: style.opacity,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // best_score ring around completed lessons.
            if (n.type == MapNodeType.lesson &&
                n.status == MapNodeStatus.completed)
              Positioned.fill(
                top: 4,
                child: CustomPaint(
                  painter: _ScoreRingPainter(
                    progress: n.bestScore / 100,
                    color: widget.topicColor.color,
                  ),
                ),
              ),
            GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: widget.onTap,
              child: button,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // viewBox 100×100, r=45, stroke 8 (web SVG).
    final scale = size.shortestSide / 100;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 45 * scale;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paint..color = AppColors.grey200);
    if (progress <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress.clamp(0, 1),
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) =>
      old.progress != progress || old.color != color;
}

/// The web's "Alınmış hediye" SVG (viewBox 48×48) drawn with paths.
class _OpenedGiftPainter extends CustomPainter {
  const _OpenedGiftPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 48, size.height / 48);
    void fill(Path p, int color) =>
        canvas.drawPath(p, Paint()..color = Color(color));

    // Box with rounded bottom corners.
    fill(
      Path()..addRRect(
        RRect.fromLTRBAndCorners(
          10,
          26,
          38,
          42,
          bottomLeft: const Radius.circular(2),
          bottomRight: const Radius.circular(2),
        ),
      ),
      0xFFF59E0B,
    );
    // Ribbon.
    fill(Path()..addRect(const Rect.fromLTRB(21, 26, 27, 42)), 0xFFDC2626);
    // Tilted lid and its ribbon.
    fill(
      Path()
        ..moveTo(7, 17.5)
        ..lineTo(38.5, 9.5)
        ..lineTo(40.5, 17)
        ..lineTo(9, 25)
        ..close(),
      0xFFFBBF24,
    );
    fill(
      Path()
        ..moveTo(20.5, 13.8)
        ..lineTo(26.3, 12.3)
        ..lineTo(28.3, 19.8)
        ..lineTo(22.5, 21.3)
        ..close(),
      0xFFEF4444,
    );
    // Bow loops.
    fill(
      Path()
        ..moveTo(23.4, 13)
        ..cubicTo(19.4, 10, 14.4, 9.5, 14.1, 12.5)
        ..cubicTo(13.8, 15.5, 19.1, 15.1, 23.4, 13)
        ..close()
        ..moveTo(23.4, 13)
        ..cubicTo(25.4, 8.5, 29.9, 6, 31.6, 8.5)
        ..cubicTo(33.3, 11, 28, 12.9, 23.4, 13)
        ..close(),
      0xFFEF4444,
    );
  }

  @override
  bool shouldRepaint(_OpenedGiftPainter old) => false;
}
