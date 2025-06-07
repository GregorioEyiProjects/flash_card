import 'package:flash_card/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? backgroundColor;
  final bool? showBackArrowLeadingiIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final double? allMargin_;
  final double? marginTop_;
  final double? marginleft_;
  final double? marginRigth_;
  final IconData? actionIcon; // The icon on the right side of the app bar
  final String? fontFamily_;

  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor = AppColors.backgroundColorWhite,
    this.showBackArrowLeadingiIcon = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.allMargin_ = 16,
    this.marginTop_ = 16,
    this.marginleft_ = 16,
    this.marginRigth_ = 16,
    this.actionIcon,
    this.fontFamily_ = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: showBackArrowLeadingiIcon!,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(left: marginleft_!),
        child: Row(
          mainAxisAlignment: mainAxisAlignment!,
          children: [
            Text(
              title ?? "",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontFamily: fontFamily_),
            ),
          ],
        ),
      ),
      actions:
          actionIcon != null
              ? [
                Padding(
                  padding: EdgeInsets.only(right: marginRigth_!),
                  child: IconButton(
                    icon: Icon(actionIcon),
                    onPressed: () {
                      // later
                      Navigator.pop(context);
                    },
                  ),
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kMinInteractiveDimension);
  //kMinInteractiveDimension
}
