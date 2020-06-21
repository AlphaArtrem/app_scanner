import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> stops;

  TopPainter(this.colors, this.stops);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;

    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);

    var gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: stops,
      colors: colors
    );

    paint.shader = gradient.createShader(rect);

    var path = Path();

    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
    canvas.drawShadow(path, colors[0], 5.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}