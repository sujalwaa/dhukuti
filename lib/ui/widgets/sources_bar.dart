import 'package:flutter/material.dart';

class SourceSegment {
  final double amount;
  final Color color;

  const SourceSegment({required this.amount, required this.color});
}

/// Horizontal proportional bar.
class SourcesBar extends StatelessWidget {
  final List<SourceSegment> segments;
  final double height;

  const SourcesBar({
    super.key,
    required this.segments,
    this.height = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0.0, (sum, item) => sum + item.amount);

    if (total == 0 || segments.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final gapWidth = 2.0;
          final totalGaps = (segments.length - 1) * gapWidth;
          final availableWidth = (totalWidth - totalGaps).clamp(0.0, double.infinity);

          return Row(
            children: List.generate(segments.length, (index) {
              final segment = segments[index];
              final width = (segment.amount / total) * availableWidth;

              return Row(
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: segment.color,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  if (index < segments.length - 1)
                    SizedBox(width: gapWidth),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
