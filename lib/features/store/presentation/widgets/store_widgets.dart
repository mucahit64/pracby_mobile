import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';

/// Tailwind colors of the web store's acorn buttons and guest banner.
const storeAmber50 = Color(0xFFFFFBEB); // bg-amber-50
const storeAmber200 = Color(0xFFFDE68A); // border-amber-200
const storeAmber600 = Color(0xFFD97706); // border-amber-600

/// Category icon of a store item, used when it has no emoji.
PbIcons storeItemIcon(String itemType) => switch (itemType) {
  'streak_freeze' => PbIcons.freeze,
  'unlimited_energy' => PbIcons.energyInfinite,
  'xp_boost' => PbIcons.xp,
  'energy_refill' => PbIcons.energy,
  _ => PbIcons.gift,
};

/// A store item's `icon_url` (an emoji) as text, like the web; falls back to
/// the category icon. [size] is the web's font size.
class StoreItemIcon extends StatelessWidget {
  const StoreItemIcon({
    required this.iconUrl,
    required this.itemType,
    required this.size,
    super.key,
  });

  final String? iconUrl;
  final String itemType;
  final double size;

  @override
  Widget build(BuildContext context) {
    final emoji = iconUrl?.trim() ?? '';
    // Real URLs aren't rendered; the backend sends emojis.
    if (emoji.isNotEmpty &&
        !emoji.startsWith('http') &&
        !emoji.startsWith('/')) {
      return Text(emoji, style: TextStyle(fontSize: size, height: 1.2));
    }
    return PbIcon(storeItemIcon(itemType), size: size * 1.2);
  }
}

/// A store section: `text-base font-extrabold` heading, then [children]
/// 12px below it (web `flex flex-col gap-3`).
class StoreSection extends StatelessWidget {
  const StoreSection({
    required this.title,
    required this.children,
    this.icon,
    super.key,
  });

  final String title;
  final PbIcons? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              PbIcon(icon!, size: 19),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

/// Spaces [children] [gap] apart (web `flex flex-col gap-*`).
class StoreList extends StatelessWidget {
  const StoreList({required this.children, this.gap = 10, super.key});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// Grey status text, e.g. "Yükleniyor…" (web `text-sm font-semibold
/// text-gray-400 py-3`).
class StoreHint extends StatelessWidget {
  const StoreHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}

/// The web's amber outlined acorn button (`bg-amber-50 border-2
/// border-amber-600 text-amber-700`). Disabled buttons fade to 40%.
class AcornButton extends StatelessWidget {
  const AcornButton({
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.4 : 1,
      child: Material(
        color: storeAmber50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: storeAmber600, width: 2),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.acorn,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// The web's 3D primary button: purple with a darker bottom edge
/// (`bg-primary border-b-* border-primary-dark`).
class StorePrimaryButton extends StatelessWidget {
  const StorePrimaryButton({
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.radius = 12,
    this.edge = 4,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  /// Height of the dark bottom edge.
  final double edge;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.6 : 1,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(radius),
            border: Border(
              bottom: BorderSide(color: AppColors.primaryDark, width: edge),
            ),
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(color: AppColors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The acorn icon and a number, e.g. a price (web `<PbIcon name="acorn" />
/// {{ n }}`). The icon is 1.2em of [fontSize].
class AcornAmount extends StatelessWidget {
  const AcornAmount(
    this.amount, {
    required this.fontSize,
    this.fontWeight = FontWeight.w800,
    this.color = AppColors.acorn,
    super.key,
  });

  final int amount;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PbIcon(PbIcons.acorn, size: fontSize * 1.2),
        SizedBox(width: fontSize * 0.3),
        Text(
          '$amount',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ],
    );
  }
}
