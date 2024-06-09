import 'package:flutter/material.dart';

class UnreadMessageCountBadge extends StatelessWidget {
  const UnreadMessageCountBadge({super.key, required this.count});

  final int count;
  final double implicitHeight = 18;

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? const SizedBox.shrink()
        : SizedBox(
            height: implicitHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(implicitHeight / 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.red,
                    width: 4,
                  ),
                  Text(
                    count > 999 ? '999+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.3,
                      backgroundColor: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    color: Colors.red,
                    width: 4,
                  ),
                ],
              ),
            ),
          );
  }
}
