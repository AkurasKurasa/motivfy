import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
      child: Row(
        children: [
          SizedBox(
            height: 26,
            width: 26,
            child: SvgPicture.asset('arrow-back.svg'),
          ),
          const SizedBox(width: 24),
          Text(
            "Notifications",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                "Mark All As Read",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
