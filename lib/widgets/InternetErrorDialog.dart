// Import necessary packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class InternetErrorDialog extends StatefulWidget {
  // Variables to hold context and error message
  var internetErrorDialogContext;
  String message;

  // Constructor for the InternetErrorDialog widget
  InternetErrorDialog(
      {super.key, required this.internetErrorDialogContext, required this.message});

  @override
  // Create the state for the InternetErrorDialog widget
  State<InternetErrorDialog> createState() => _InternetErrorDialogState(
      internetErrorDialogContext: internetErrorDialogContext, message: message);
}

class _InternetErrorDialogState extends State<InternetErrorDialog> {
  // Variables to hold context and error message
  var internetErrorDialogContext;
  String message;

  // Constructor for the state of the InternetErrorDialog widget
  _InternetErrorDialogState(
      {required this.internetErrorDialogContext, required this.message});

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    // Return a container with specific layout
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: MediaQuery.of(context).size.height * 0.25),
      height: MediaQuery.of(context).size.height * 0.5,
      // Add background decoration with an image
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      // Use a Stack to position child widgets
      child: Stack(
        children: [
          // Position the internet error animation within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.065,
              left: MediaQuery.of(context).size.width * 0.32,
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.28,
              child: LottieBuilder.asset(
                "assets/Animation/internet_error.json",
                height: 140,
                width: 140,
                fit: BoxFit.contain,
                repeat: false,
              )),
          // Position the error title within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.17,
              left: MediaQuery.of(context).size.width * 0.30,
              right: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Internet Error",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.red,
                    fontFamily: "Fontmain",
                    fontSize: 20),
              )),
          // Position the error message within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.21,
              left: MediaQuery.of(context).size.width * 0.12,
              right: MediaQuery.of(context).size.width * 0.12,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.5,
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    color: Colors.red,
                    height: 1.5,
                    fontSize: 17),
              )),
          // Position the OK button within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.29,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(
                        Duration(milliseconds: 600),
                        () {
                          exit(0);
                        },
                      );
                      Navigator.pop(internetErrorDialogContext);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 18, fontFamily: "Fontmain"),
                    ),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 3),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.055)),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
