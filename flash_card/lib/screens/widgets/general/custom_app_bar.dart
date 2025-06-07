import 'package:flash_card/app_colors.dart';
import 'package:flutter/material.dart';

//UNUSED
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isLeadingIconEnabled;
  final Widget? leading;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomAppBar({
    super.key,
    this.title,
    this.isLeadingIconEnabled = false,
    this.leading,
    this.backgroundColor = AppColors.backgroundColorWhite,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? "",
        style: TextStyle(
          color: AppColors.textInBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Navigate to settings screen
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
