import 'package:flutter/material.dart';

/// Represents a widget for displaying weekly analytics data.
class AnalyticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? barData;
  final List<String>? days;
  final List<LegendItem>? legendItems;
  final String? timeLabel;
  final int? streak;

  const AnalyticsWidget({
    super.key,
    this.barData,
    this.days,
    this.legendItems,
    this.timeLabel,
    this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final bars =
        barData ??
        List.generate(7, (_) => {"height": 0.0, "color": Colors.grey});
    final dayLabels = days ?? ["S", "M", "T", "W", "TH", "F", "S"];
    final legends =
        legendItems ??
        [
          LegendItem(const Color(0xFFFE9933), "Zoned out"),
          LegendItem(const Color(0xFF0F63E2), "Focused"),
        ];
    final String time = timeLabel ?? "--:--:--";

    final screenWidth = MediaQuery.of(context).size.width;

    // \\ Base screen width = 375 (e.g. iPhone 11 Pro)
    final double scaleFactor = (screenWidth / 375).clamp(0.9, 1.4);

    final fontSize = 10.0 * scaleFactor;
    final barDotSize = 10.0 * scaleFactor;
    final barWidth = 8.0 * scaleFactor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 160;
        final barHeightLimit = maxHeight * 0.3;

        return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Weekly Streak",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6 * scaleFactor),

                // 🔷 Main bar & dots
                SizedBox(
                  height: 100 * scaleFactor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left dots
                      SizedBox(
                        width: 50 * scaleFactor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Wrap(
                              spacing: 4 * scaleFactor,
                              runSpacing: 4 * scaleFactor,
                              children: List.generate(15, (index) {
                                final isActive = barData != null
                                    ? index < 8
                                    : false;
                                return Container(
                                  width: barDotSize,
                                  height: barDotSize,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF0F63E2)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 4 * scaleFactor),
                            Text(
                              "Streak: ${streak ?? '--'}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize - 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8 * scaleFactor),

                      // Right bars
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            final bar = bars[index];
                            return Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: barWidth.clamp(6.0, 18.0),
                                    height: ((bar["height"] as double).clamp(
                                      0,
                                      barHeightLimit,
                                    )).toDouble(),
                                    decoration: BoxDecoration(
                                      color: bar["color"] as Color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(height: 4 * scaleFactor),
                                  Text(
                                    dayLabels[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize - 2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10 * scaleFactor),

                // 🔷 Legends + Timer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildLegends(context, legends, fontSize)),
                    SizedBox(width: 5 * scaleFactor),
                    Container(
                      constraints: BoxConstraints(minWidth: 45 * scaleFactor),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8 * scaleFactor,
                        vertical: 2 * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: (timeLabel != null && timeLabel != "--:--:--")
                            ? const Color(0xFF0F63E2)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize - 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegends(
    BuildContext context,
    List<LegendItem> legends,
    double fontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;

    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: legends.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildLegendItem(item.color, item.label, fontSize),
          );
        }).toList(),
      );
    } else {
      return Wrap(
        spacing: 12,
        runSpacing: 4,
        children: legends.map((item) {
          return _buildLegendItem(item.color, item.label, fontSize);
        }).toList(),
      );
    }
  }

  Widget _buildLegendItem(Color color, String text, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: fontSize - 2),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class LegendItem {
  final Color color;
  final String label;

  LegendItem(this.color, this.label);
}
