import 'package:appscanner/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopPainter extends CustomPainter {
  final Color mainColor;

  TopPainter(this.mainColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = mainColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}