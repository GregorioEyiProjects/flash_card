import 'package:flash_card/app_colors.dart';
import 'package:flutter/material.dart';

class CustomFavIcon extends StatefulWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final bool? isFavorite;
  const CustomFavIcon({
    super.key,
    this.color = AppColors.iconColor,
    this.isFavorite = false,
    this.onPressed,
  });

  @override
  State<CustomFavIcon> createState() => _CustomFavIconState();
}

class _CustomFavIconState extends State<CustomFavIcon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: widget.onPressed,
          icon: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.backgroundColorWhite,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              widget.isFavorite!
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: widget.color,
            ),
          ),
        ),
      ],
    );
  }
}
