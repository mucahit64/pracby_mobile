import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/utils/oklch.dart';
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
    // Like a lesson: finished once is completed (and can be replayed), with
    // its best score.
    final finished = topic.progress?.finalCompletedAt != null;
    nodes.add(
      MapNode(
        type: MapNodeType.boss,
        status: finished
            ? MapNodeStatus.completed
            : allDone
            ? MapNodeStatus.active
            : MapNodeStatus.locked,
        bestScore: topic.progress?.finalBestScore ?? 0,
      ),
    );
  }
  return nodes;
}

/// Horizontal zigzag offsets, repeating every 5 nodes (web: 0/40/65/40/0px).
double nodeOffset(int index) => const <double>[0, 40, 65, 40, 0][index % 5];

/// Diameter of a map button (web `PbStepCoin` :size="84").
const mapNodeDiameter = 84.0;

/// A map button drawn as a tilted coin, like the web's `PbStepCoin`: a face
/// with a lighter rim band over a cylinder side, and a best-score ring
/// around it. Pressing lowers only the face. A full score is gold with a
/// trophy (a crown for the boss) and no ring.
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

enum _CoinIcon { svg, openedGift, trophy, crown }

typedef _CoinLook = ({
  Color face,
  Color side,
  _CoinIcon iconKind,
  PbIcons icon,
  int? score,
  bool dim,
  bool fadedIcon,
  String label,
});

class _MapNodeViewState extends State<MapNodeView> {
  bool _pressed = false;

  // Proportions shared with the web (PbStepCoin.vue).
  static const _tilt = 0.88;
  static const _thickness = 0.12;
  static const _rimWidth = 0.1;
  static const _rimLighten = 0.06;

  static const _amber100 = Color(0xFFFEF3C7);
  static const _gold = Color(0xFFFFC800);
  static const _goldSide = Color(0xFFE5A500);

  _CoinLook get _look {
    final n = widget.node;
    final locked = n.status == MapNodeStatus.locked;
    final score = n.status == MapNodeStatus.completed ? n.bestScore : null;
    _CoinLook look({
      required Color face,
      required Color side,
      required PbIcons icon,
      required String label,
      _CoinIcon iconKind = _CoinIcon.svg,
      int? score,
      bool dim = false,
      bool fadedIcon = false,
    }) => (
      face: face,
      side: side,
      iconKind: iconKind,
      icon: icon,
      score: score,
      dim: dim,
      fadedIcon: fadedIcon,
      label: label,
    );

    switch (n.type) {
      case MapNodeType.chest:
        return switch (n.status) {
          MapNodeStatus.completed => look(
            face: _amber100,
            side: const Color(0xFFFCD34D),
            icon: PbIcons.gift,
            iconKind: _CoinIcon.openedGift,
            label: 'Sandık, alındı',
          ),
          MapNodeStatus.locked => look(
            face: _amber100,
            side: const Color(0xFFD97706),
            icon: PbIcons.gift,
            dim: true,
            label: 'Sandık, kilitli',
          ),
          MapNodeStatus.active => look(
            face: AppColors.warning,
            side: const Color(0xFFCC7800),
            icon: PbIcons.gift,
            label: 'Sandık',
          ),
        };
      case MapNodeType.boss:
        if (locked) {
          return look(
            face: AppColors.grey200,
            side: AppColors.grey400,
            icon: PbIcons.swords,
            fadedIcon: true,
            label: 'Konu sonu testi, kilitli',
          );
        }
        return look(
          face: AppColors.error,
          side: const Color(0xFFCC2222),
          icon: PbIcons.swords,
          score: score,
          label: score == null
              ? 'Konu sonu testi'
              : 'Konu sonu testi, $score puan',
        );
      case MapNodeType.lesson:
        if (locked) {
          return look(
            face: AppColors.grey200,
            side: AppColors.grey400,
            icon: PbIcons.lock,
            label: 'Ders, kilitli',
          );
        }
        return look(
          face: widget.topicColor.color,
          side: widget.topicColor.shadow,
          icon: PbIcons.test,
          score: score,
          label: score == null ? 'Ders' : 'Ders, $score puan',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final look = _look;
    final perfect = look.score == 100;
    final face = perfect ? _gold : look.face;
    final side = perfect ? _goldSide : look.side;
    final iconKind = perfect
        ? (widget.node.type == MapNodeType.boss
              ? _CoinIcon.crown
              : _CoinIcon.trophy)
        : look.iconKind;
    // A full score has no ring: the coin turns gold instead.
    final ringScore = perfect ? null : look.score;

    const d = mapNodeDiameter;
    const faceHeight = d * _tilt;
    const depth = d * _thickness;
    const ringGap = d * 6 / 70;
    const ringWidth = d * 8 / 70;
    const box = d + 2 * (ringGap + ringWidth);
    const iconSize = d * 0.504;

    final enabled = widget.onTap != null;
    final pressed = _pressed && enabled;

    var icon = switch (iconKind) {
      _CoinIcon.svg => PbIcon(look.icon, size: iconSize),
      _CoinIcon.openedGift => const SizedBox.square(
        dimension: iconSize,
        child: CustomPaint(painter: _OpenedGiftPainter()),
      ),
      _CoinIcon.trophy => const _StruckIcon(path: _trophyPath, size: iconSize),
      _CoinIcon.crown => const _StruckIcon(path: _crownPath, size: iconSize),
    };
    // A completed lesson shows its best score instead of its icon. A boss
    // keeps its swords so it reads as the boss; its score is on the ring.
    if (ringScore != null && widget.node.type == MapNodeType.lesson) {
      icon = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$ringScore',
            style: const TextStyle(
              fontSize: d * 0.3,
              height: 1,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: d * 0.02),
          Text(
            'puan',
            style: TextStyle(
              fontSize: d * 0.13,
              height: 1,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      );
    }
    if (look.fadedIcon) {
      icon = Opacity(
        opacity: 0.5,
        child: ColorFiltered(colorFilter: _greyscale, child: icon),
      );
    }

    final coin = TweenAnimationBuilder<double>(
      tween: Tween(end: pressed ? depth : 0),
      duration: const Duration(milliseconds: 150),
      builder: (context, press, _) => SizedBox(
        width: d,
        height: faceHeight + depth,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CoinPainter(
                  face: face,
                  side: side,
                  rim: lightenOklch(face, _rimLighten),
                  press: press,
                  faceHeight: faceHeight,
                  depth: depth,
                  rimWidth: d * _rimWidth,
                  tilt: _tilt,
                ),
              ),
            ),
            Positioned(
              top: press,
              left: 0,
              width: d,
              height: faceHeight,
              child: Center(child: icon),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: look.label,
      excludeSemantics: true,
      child: Opacity(
        opacity: look.dim ? 0.6 : 1,
        child: SizedBox.square(
          dimension: box,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (ringScore != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ScoreRingPainter(
                      progress: ringScore / 100,
                      color: face,
                      width: ringWidth,
                    ),
                  ),
                ),
              GestureDetector(
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                onTap: widget.onTap,
                child: coin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

// Single-colour icons for a full score, as if struck into the gold coin
// (the web's PbStepCoin uses the same paths, viewBox 24×24).
const _trophyPath =
    'M6 3h12v2h2.5a1 1 0 0 1 1 1v1.5A4.5 4.5 0 0 1 17.3 12 6 6 0 0 1 13 '
    '15.9V18h3a1 1 0 0 1 1 1v2H7v-2a1 1 0 0 1 1-1h3v-2.1A6 6 0 0 1 6.7 '
    '12 4.5 4.5 0 0 1 2.5 7.5V6a1 1 0 0 1 1-1H6V3Zm0 4H4.5v.5A2.5 2.5 0 '
    '0 0 6.2 9.9 6 6 0 0 1 6 9V7Zm12 0v2a6 6 0 0 1-.2 .9 2.5 2.5 0 0 0 '
    '1.7-2.4V7H18Z';
const _crownPath =
    'M2.5 7.5a1.5 1.5 0 0 1 2.4-1.2l3.4 2.6 2.4-4.1a1.5 1.5 0 0 1 2.6 '
    '0l2.4 4.1 3.4-2.6a1.5 1.5 0 0 1 2.4 1.4l-1.5 9.3a1 1 0 0 1-1 '
    '.8H5a1 1 0 0 1-1-.8L2.5 7.7ZM5 19.5h14a1 1 0 0 1 1 1v.5a1 1 0 0 '
    '1-1 1H5a1 1 0 0 1-1-1v-.5a1 1 0 0 1 1-1Z';

class _StruckIcon extends StatelessWidget {
  const _StruckIcon({required this.path, required this.size});

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> '
    '<path fill="#C98A00" d="$path"/></svg>',
    width: size,
    height: size,
  );
}

/// The coin: the cylinder side, then the face with its rim band. The side
/// starts at the face's widest line wherever the pressed face is, so the
/// face never uncovers its corners; its bottom edge stays put.
class _CoinPainter extends CustomPainter {
  const _CoinPainter({
    required this.face,
    required this.side,
    required this.rim,
    required this.press,
    required this.faceHeight,
    required this.depth,
    required this.rimWidth,
    required this.tilt,
  });

  final Color face;
  final Color side;
  final Color rim;
  final double press;
  final double faceHeight;
  final double depth;
  final double rimWidth;
  final double tilt;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final wallTop = faceHeight / 2 + press;
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, wallTop, w, size.height))
      ..drawPath(
        Path()
          ..addRect(Rect.fromLTRB(0, wallTop, w, faceHeight / 2 + depth))
          ..addOval(Rect.fromLTWH(0, depth, w, faceHeight)),
        Paint()..color = side,
      )
      ..restore();

    final faceRect = Rect.fromLTWH(0, press, w, faceHeight);
    canvas
      ..drawOval(faceRect, Paint()..color = rim)
      ..drawOval(
        Rect.fromLTRB(
          faceRect.left + rimWidth,
          faceRect.top + rimWidth * tilt,
          faceRect.right - rimWidth,
          faceRect.bottom - rimWidth * tilt,
        ),
        Paint()..color = face,
      );
  }

  @override
  bool shouldRepaint(_CoinPainter old) =>
      old.face != face ||
      old.side != side ||
      old.rim != rim ||
      old.press != press;
}

/// Best-score ring: a grey track and the part the score fills, from the top
/// clockwise. Nothing at 0: a round cap would draw a dot.
class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.width,
  });

  final double progress;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - width) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
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
      old.progress != progress || old.color != color || old.width != width;
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
