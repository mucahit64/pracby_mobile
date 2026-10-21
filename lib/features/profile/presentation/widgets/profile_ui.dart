import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';

/// Building blocks shared by the profile screen and its dialogs, styled
/// after the web profile page's Tailwind classes.

/// CSS `uppercase` with a Turkish locale: "i" becomes "İ" ("SERİ", "QUİZ").
String trUpper(String text) => text.replaceAll('i', 'İ').toUpperCase();

/// Section heading with a leading icon (`h2 text-base font-extrabold`).
class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({
    required this.icon,
    required this.text,
    super.key,
  });

  final PbIcons icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PbIcon is 1.2em of the 16px heading.
        PbIcon(icon, size: 19),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w800,
              color: AppColors.grey800,
            ),
          ),
        ),
      ],
    );
  }
}

/// White button with a 2px gray border (`bg-white border-2 border-gray-200
/// rounded-xl py-3 text-sm font-bold`).
class ProfileOutlineButton extends StatelessWidget {
  const ProfileOutlineButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.grey400,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.grey200, width: 2),
    );
    return Material(
      color: Colors.white,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: Padding(
          // py-3 plus the 2px border, which the shape doesn't lay out.
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 5)],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w700,
                    color: color,
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

/// Solid button with a 4px darker bottom edge that sinks when pressed
/// (`border-b-4 active:border-b-0 active:translate-y-1`). Faded when
/// [onPressed] is null (`disabled:opacity-60`).
class ProfilePressButton extends StatefulWidget {
  const ProfilePressButton({
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.edgeColor = AppColors.primaryDark,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color edgeColor;

  @override
  State<ProfilePressButton> createState() => _ProfilePressButtonState();
}

class _ProfilePressButtonState extends State<ProfilePressButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final pressed = enabled && _pressed;
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: Padding(
          // The edge disappears and the face moves down by its height.
          padding: EdgeInsets.only(top: pressed ? 4 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(12),
              border: pressed
                  ? null
                  : Border(
                      bottom: BorderSide(color: widget.edgeColor, width: 4),
                    ),
            ),
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The web profile's modal card (`bg-white border-2 border-gray-200
/// rounded-2xl p-5 gap-5`) with the round ✕ close button in the corner.
class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    required this.children,
    this.maxWidth = 380,
    this.onClose,
    super.key,
  });

  final List<Widget> children;
  final double maxWidth;

  /// Defaults to closing the dialog.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.grey200, width: 2),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(height: 20),
                    children[i],
                  ],
                ],
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: GestureDetector(
                onTap: onClose ?? () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grey200, width: 2),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.grey400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog heading (`text-lg font-black text-gray-800`).
class ProfileDialogTitle extends StatelessWidget {
  const ProfileDialogTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w900,
        color: AppColors.grey800,
      ),
    );
  }
}

/// Red request error inside a dialog (`text-negative text-sm font-semibold`).
class ProfileDialogError extends StatelessWidget {
  const ProfileDialogError(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: AppColors.error,
      ),
    );
  }
}

/// CSS `border-dashed`: draws a dashed rounded border over [child].
class DashedBorder extends StatelessWidget {
  const DashedBorder({
    required this.child,
    required this.color,
    required this.radius,
    this.width = 2,
    super.key,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: color,
        radius: radius,
        width: width,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.width,
  });

  final Color color;
  final double radius;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(width / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - width / 2)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final dash = width * 3;
    final gap = width * 2;
    for (final metric in path.computeMetrics()) {
      // Spread the leftover so the dashes meet evenly around the shape.
      final count = (metric.length / (dash + gap)).floor().clamp(1, 1 << 20);
      final step = metric.length / count;
      for (var i = 0; i < count; i++) {
        final start = i * step;
        canvas.drawPath(metric.extractPath(start, start + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius || old.width != width;
}
