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
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      // Use a Stack to position child widgets
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.065,
            child: LottieBuilder.asset(
              "assets/Animation/internet_error.json",

              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.025,
            child: Text(
              ErrorTitle,
              style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  fontFamily: "mainFont"),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.75,
            child: Text(
              Description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 15,
                  fontFamily: "mainFont",
                  decoration: TextDecoration.none),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.06,
            width: MediaQuery.sizeOf(context).width * 0.35,
            child: ElevatedButton(
              onPressed: reTryButton,
              child: Text(ButtonText, style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.red.shade900, width: 2.5)),
            ),
          )
        ],
      ),
    );
  }
}
