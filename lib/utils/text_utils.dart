import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? color;
  final double? size;
  final bool? weight;
  final VoidCallback? onPressed;

  const TextUtil({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.size,
    this.color,
    this.weight,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: width,
        child: Text(
          text,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: size ?? 16,
            fontWeight: weight != true ? FontWeight.w400 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
