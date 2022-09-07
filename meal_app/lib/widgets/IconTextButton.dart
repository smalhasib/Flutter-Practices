import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;

  IconTextButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 6,
          ),
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
          ),
        )
      ],
    );
  }
}
