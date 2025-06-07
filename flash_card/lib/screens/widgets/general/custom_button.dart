import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  //
  final String? text;
  final double? height;
  final double? width;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final double fontSize;
  final String fontFamily;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    this.height = 50,
    this.width = 110,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.fontFamily = "Poppins",
    this.backgroundColor = Colors.black87,
    required this.onTap,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.90;
    });
    debugPrint("onTapDown");
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Return to original size
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Reset if the tap is canceled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          /**/ height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Center(
            child: Text(
              widget.text!,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
                fontFamily: widget.fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
