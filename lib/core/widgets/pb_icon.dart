import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Pracby's own icon set. The same SVG files are used on the web
/// (pracby/client/assets/icons), so both clients look identical.
enum PbIcons {
  acorn('acorn'),
  book('book'),
  calendar('calendar'),
  cart('cart'),
  check('check'),
  diamond('diamond'),
  door('door'),
  energy('energy'),
  energyEmpty('energy-empty'),
  energyInfinite('energy-infinite'),
  fire('fire'),
  freeze('freeze'),
  gift('gift'),
  graduation('graduation'),
  infinity('infinity'),
  lock('lock'),
  mail('mail'),
  medal('medal'),
  medalBronze('medal-bronze'),
  medalGold('medal-gold'),
  medalSilver('medal-silver'),
  profile('profile'),
  settings('settings'),
  swords('swords'),
  target('target'),
  test('test'),
  trash('trash'),
  trophy('trophy'),
  warning('warning'),
  xp('xp');

  const PbIcons(this.file);

  final String file;
}

class PbIcon extends StatelessWidget {
  const PbIcon(this.icon, {this.size = 24, super.key});

  final PbIcons icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/${icon.file}.svg',
      width: size,
      height: size,
    );
  }
}
