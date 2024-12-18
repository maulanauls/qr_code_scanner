import 'dart:math';

import 'package:flutter/material.dart';

class QrScannerOverlayShape extends ShapeBorder {
  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
        (cutOutWidth == null && cutOutHeight == null) ||
            (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
        'Use only cutOutWidth and cutOutHeight or only cutOutSize',);
  }

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
  final double width = rect.width;
  final double height = rect.height;
  final double borderOffset = borderWidth / 2;
  
  // Adjusted border length based on cutOut dimensions
  final double adjustedBorderLength = borderLength > min(cutOutHeight, cutOutWidth) / 2 + borderWidth * 2
      ? width / 4
      : borderLength;
  
  // Calculated cutout width and height based on constraints
  final double calculatedCutOutWidth = cutOutWidth < width ? cutOutWidth : width - borderOffset;
  final double calculatedCutOutHeight = cutOutHeight < height ? cutOutHeight : height - borderOffset;

  final backgroundPaint = Paint()
    ..color = overlayColor
    ..style = PaintingStyle.fill;

  final borderPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;

  final boxPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  final cutOutRect = Rect.fromLTWH(
    rect.left + width / 2 - calculatedCutOutWidth / 2 + borderOffset,
    -cutOutBottomOffset +
        rect.top +
        height / 2 -
        calculatedCutOutHeight / 2 +
        borderOffset,
    calculatedCutOutWidth - borderOffset * 2,
    calculatedCutOutHeight - borderOffset * 2,
  );

  canvas
    ..saveLayer(
      rect,
      backgroundPaint,
    )
    ..drawRect(
      rect,
      backgroundPaint,
    )
    // Draw top right corner
    ..drawRRect(
      RRect.fromLTRBAndCorners(
        cutOutRect.right - adjustedBorderLength,
        cutOutRect.top,
        cutOutRect.right,
        cutOutRect.top + adjustedBorderLength,
        topRight: Radius.circular(borderRadius),
      ),
      borderPaint,
    )
    // Draw top left corner
    ..drawRRect(
      RRect.fromLTRBAndCorners(
        cutOutRect.left,
        cutOutRect.top,
        cutOutRect.left + adjustedBorderLength,
        cutOutRect.top + adjustedBorderLength,
        topLeft: Radius.circular(borderRadius),
      ),
      borderPaint,
    )
    // Draw bottom right corner
    ..drawRRect(
      RRect.fromLTRBAndCorners(
        cutOutRect.right - adjustedBorderLength,
        cutOutRect.bottom - adjustedBorderLength,
        cutOutRect.right,
        cutOutRect.bottom,
        bottomRight: Radius.circular(borderRadius),
      ),
      borderPaint,
    )
    // Draw bottom left corner
    ..drawRRect(
      RRect.fromLTRBAndCorners(
        cutOutRect.left,
        cutOutRect.bottom - adjustedBorderLength,
        cutOutRect.left + adjustedBorderLength,
        cutOutRect.bottom,
        bottomLeft: Radius.circular(borderRadius),
      ),
      borderPaint,
    )
    ..drawRRect(
      RRect.fromRectAndRadius(
        cutOutRect,
        Radius.circular(borderRadius),
      ),
      boxPaint,
    )
    ..restore();
  }
  

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
