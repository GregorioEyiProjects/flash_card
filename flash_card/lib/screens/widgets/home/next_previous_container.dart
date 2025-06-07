import 'package:flash_card/screens/widgets/general/custom_button.dart';
import 'package:flutter/material.dart';

class NextPreviousContainer extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const NextPreviousContainer({super.key, this.onNext, this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Previous button
        CustomButton(
          text: "Previuos",
          onTap: () {
            if (onPrevious != null) {
              onPrevious!();
            }
          },
        ),
        /* ElevatedButton(
          onPressed: () {
            if (onPrevious != null) {
              onPrevious!();
            }
          },
          child: Text(
            'Previous',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ), */

        //Next button
        CustomButton(
          text: "Next",
          onTap: () {
            if (onNext != null) {
              onNext!();
            }
          },
        ),

        /*         ElevatedButton(
          onPressed: () {
            if (onNext != null) {
              onNext!();
            }
          },
          child: Text(
            'Next',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ), */
      ],
    );
  }
}
