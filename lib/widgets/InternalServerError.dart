// Import necessary packages
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class InternalserverError extends StatefulWidget {
  // Variables to hold context, error title, description, retry button function, and button text
  var InternalserverErrorContext;
  String ErrorTitle;
  String Description;
  var retryButton;
  String ButtonText;

  // Constructor for the InternalserverError widget
  InternalserverError(
      {super.key,
      required this.InternalserverErrorContext,
      required this.ErrorTitle,
      required this.Description,
      required this.retryButton,
      required this.ButtonText});

  @override
  // Create the state for the InternalserverError widget
  State<InternalserverError> createState() => _InternalserverErrorState(
      InternalserverErrorContex: InternalserverErrorContext,
      ErrorTitle: ErrorTitle,
      Description: Description,
      reTryButton: retryButton,
      ButtonText: ButtonText);
}

class _InternalserverErrorState extends State<InternalserverError> {
  // Variables to hold context, error title, description, retry button function, and button text
  var InternalserverErrorContex;
  String ErrorTitle;
  String Description;
  String ButtonText;
  var reTryButton;

  // Constructor for the state of the InternalserverError widget
  _InternalserverErrorState(
      {required this.InternalserverErrorContex,
      required this.ErrorTitle,
      required this.Description,
      required this.reTryButton,
      required this.ButtonText});

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
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      // Use a Stack to position child widgets
      child: Stack(
        children: [
          // Position the internet error animation within the stack
          Positioned(
              left: MediaQuery.of(context).size.width * 0.25,
              bottom: MediaQuery.of(context).size.height * 0.36,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.104),
                height: MediaQuery.of(context).size.height * 0.08,
                child: LottieBuilder.asset(
                  "assets/Animation/internet_error.json",
                  height: 140,
                  width: 140,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              )),
          // Position the error title within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.159,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                child: Center(
                  child: Text(
                    ErrorTitle,
                    style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.none,
                        fontFamily: "mainFont"),
                  ),
                ),
              )),
          // Position the error description within the stack
          Positioned(
            top: MediaQuery.of(context).size.height * 0.195,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  Description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 15,
                      fontFamily: "mainFont",
                      decoration: TextDecoration.none),
                )),
          ),
          // Position the retry button within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.29,
              left: MediaQuery.of(context).size.width * 0.3,
              right: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: reTryButton,
                child: Text(ButtonText, style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red.shade900, width: 2.5)),
              ))
        ],
      ),
    );
  }
}
