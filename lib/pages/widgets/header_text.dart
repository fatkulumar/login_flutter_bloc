import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20)),
            Text(
              subtitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset("assets/images/close-image.png", height: 30, width: 30),
        ),
      ],
    );
  }
}
