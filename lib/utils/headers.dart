import 'package:flutter/material.dart';
import 'package:pardna/utils/text_utils.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onPressed;

  const HomeHeader({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 35),
            onPressed: onPressed,
          ),
          const TextUtil(
            text: "PARDNA",
            weight: true,
            color: Colors.black,
            size: 25,
          ),
        ],
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  final VoidCallback? onPressed;

  const DetailHeader({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              weight: 700,
              size: 20,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            TextUtil(
              text: "Back",
              weight: true,
              color: Colors.black,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
