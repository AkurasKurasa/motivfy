import 'package:flutter/material.dart';

/// A reusable slider widget for settings
class SettingsSliderTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final IconData? leadingIcon;
  final String Function(double)? valueFormatter;

  const SettingsSliderTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.leadingIcon,
    this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) Text(subtitle!),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            label: valueFormatter != null
                ? valueFormatter!(value)
                : value.toString(),
          ),
        ],
      ),
      leading: leadingIcon != null ? Icon(leadingIcon) : null,
    );
  }
}
