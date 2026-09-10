import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/theme/app_typography.dart';

class DonutSegment {
  final double value;
  final Color color;

  const DonutSegment({required this.value, required this.color});
}

/// CustomPainter donut chart.
class DonutChart extends StatefulWidget {
  final List<DonutSegment> data;
  final double size;
  final double strokeWidth;
  final Widget? centerWidget;

  const DonutChart({
    super.key,
    required this.data,
    this.size = 190.0,
    this.strokeWidth = 32.0,
    this.centerWidget,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _DonutPainter(
                  data: widget.data,
                  strokeWidth: widget.strokeWidth,
                  progress: _animation.value,
                ),
              );
            },
          ),
          if (widget.centerWidget != null) widget.centerWidget!,
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> data;
  final double strokeWidth;
  final double progress;

  _DonutPainter({
    required this.data,
    required this.strokeWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = data.fold(0, (sum, item) => sum + item.value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Convert 2px gap to radians
    final gapRadians = 2.0 / radius; 
    
    double startAngle = -pi / 2; // Start from top

    for (final segment in data) {
      final sweepAngle = (segment.value / total) * 2 * pi * progress;
      
      if (sweepAngle > gapRadians) {
        final paint = Paint()
          ..color = segment.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + gapRadians / 2,
          sweepAngle - gapRadians,
          false,
          paint,
        );
      }
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}
