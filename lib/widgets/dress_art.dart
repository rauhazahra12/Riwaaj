import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DressArt extends StatelessWidget {
  const DressArt({
    super.key,
    required this.index,
    this.dressColor,
    this.backgroundColor,
  });

  final int index;
  final Color? dressColor;
  final Color? backgroundColor;

  static const List<Color> _bgPalette = [
    AppColors.pink,
    Color(0xffe5e5dc),
    Color(0xfff2d27f),
    Color(0xff273a48),
    Color(0xffd8e3d8),
    Color(0xfffbe3d5),
  ];

  static const List<Color> _dressPalette = [
    AppColors.red,
    AppColors.green,
    AppColors.blue,
    AppColors.gold,
    AppColors.ruby,
    Color(0xff8b3a62),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? _bgPalette[index % _bgPalette.length];
    final dress = dressColor ?? _dressPalette[index % _dressPalette.length];

    return Container(
      color: bg,
      child: CustomPaint(
        painter: DressPainter(color: dress),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class DressPainter extends CustomPainter {
  DressPainter({this.color = AppColors.blue});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * 0.5;
    final y = size.height * 0.22;

    final inkPaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fabricPaint = Paint()..color = color;

    // Hanger / Neckline
    final hangerPath = Path()
      ..moveTo(x - 40, y + 15)
      ..quadraticBezierTo(x, y - 6, x + 40, y + 15)
      ..moveTo(x, y + 6)
      ..cubicTo(x - 4, y - 4, x + 5, y - 13, x + 10, y - 14);
    canvas.drawPath(hangerPath, inkPaint);

    // Choli / Bodice
    final bodicePath = Path()
      ..moveTo(x - 23, y + 21)
      ..lineTo(x - 15, y + 62)
      ..lineTo(x + 15, y + 62)
      ..lineTo(x + 23, y + 21)
      ..lineTo(x + 10, y + 14)
      ..lineTo(x, y + 28)
      ..lineTo(x - 10, y + 14)
      ..close();
    canvas.drawPath(bodicePath, fabricPaint);
    canvas.drawPath(bodicePath, inkPaint);

    // Flared Skirt / Lehenga
    final skirtPath = Path()
      ..moveTo(x - 15, y + 62)
      ..lineTo(x + 15, y + 62)
      ..cubicTo(x + 24, y + 108, x + 54, y + 152, x + 70, y + 188)
      ..quadraticBezierTo(x, y + 200, x - 70, y + 188)
      ..cubicTo(x - 54, y + 152, x - 24, y + 108, x - 15, y + 62)
      ..close();
    canvas.drawPath(skirtPath, fabricPaint);
    canvas.drawPath(skirtPath, inkPaint);

    // Zari / Gold hem trim
    final goldTrim = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;
    canvas.drawPath(
      Path()
        ..moveTo(x - 50, y + 173)
        ..quadraticBezierTo(x, y + 188, x + 50, y + 173),
      goldTrim,
    );

    // Dupatta / Drape
    final dupattaPaint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(
      Path()
        ..moveTo(x + 40, y + 25)
        ..cubicTo(x + 100, y + 8, x + 78, y + 98, x + 130, y + 83)
        ..cubicTo(x + 165, y + 70, x + 133, y + 158, x + 180, y + 142),
      dupattaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant DressPainter oldDelegate) =>
      oldDelegate.color != color;
}
