import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color titleColor;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.titleColor = Colors.black,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: backgroundColor ?? Colors.grey[200],
      padding: const EdgeInsets.only(top: 48, left: 30, right: 30, bottom: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
