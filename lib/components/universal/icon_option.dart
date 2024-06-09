import 'package:flutter/material.dart';

class IconOption extends StatelessWidget {
  const IconOption({
    super.key,
    required this.icon,
    this.padding = EdgeInsets.zero,
    required this.text,
    this.height = 28,
    this.onTap,
    this.color,
  });

  final void Function()? onTap;
  final double height;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color ?? theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: color ?? theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
