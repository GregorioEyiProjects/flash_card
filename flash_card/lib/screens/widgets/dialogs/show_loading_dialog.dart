import 'package:flutter/material.dart';

BuildContext? dialogContext;

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      dialogContext =
          context; // Assign the dialog context to the global variable
      return AlertDialog(
        title: Text(
          'Loading...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              "Processing, please wait...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    },
  );
}

//Show a loading dialog with a custom message
void showLoadingIconDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Searching, Please Wait',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void customLoadingIconDialog(
  BuildContext context,
  String title,
  String message,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Center(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
