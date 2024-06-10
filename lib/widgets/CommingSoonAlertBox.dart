// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class commingSoonAlertbox extends StatefulWidget {
  // Define a variable to hold the dialog context
  var comingSoonDialogContext;

  // Constructor for the commingSoonAlertbox widget
  commingSoonAlertbox({super.key, required this.comingSoonDialogContext});

  @override
  // Create the state for the commingSoonAlertbox widget
  State<commingSoonAlertbox> createState() =>
      _commingSoonAlertboxState(comingSoonDialogContext);
}

// Define the state class for the commingSoonAlertbox widget
class _commingSoonAlertboxState extends State<commingSoonAlertbox> {
  // Define a variable to hold the dialog context
  var comingSoonDialogContext;

  // Constructor for the state class, accepting the dialog context
  _commingSoonAlertboxState(this.comingSoonDialogContext);

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    return Container(
      // Define margin for the container
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: MediaQuery.of(context).size.height * 0.3),
      // Add a background image to the container
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      child: Stack(
        children: [
          // Position the Lottie animation within the stack
          Positioned(
            // Set the position from the top of the screen
            top: MediaQuery.of(context).size.height * 0.025,
            // Set the position from the left of the screen
            left: MediaQuery.of(context).size.width * 0.285,
            // Set the height of the Lottie animation
            height: MediaQuery.of(context).size.height * 0.12,
            // Set the width of the Lottie animation
            width: MediaQuery.of(context).size.width * 0.35,
            // Add the Lottie animation asset
            child: LottieBuilder.asset(
              "assets/Animation/Animation - 1711598825358.json",
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          // Position the description text within the stack
          Positioned(
            // Set the position from the top of the screen
            top: MediaQuery.of(context).size.height * 0.185,
            // Set the position from the left of the screen
            left: MediaQuery.of(context).size.width * 0.1,
            // Set the position from the right of the screen
            right: MediaQuery.of(context).size.width * 0.1,
            // Add the description text
            child: Text(
              "This section will be published shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Fontmain",
                decoration: TextDecoration.none,
                height: 1.5,
              ),
            ),
          ),
          // Position the button within the stack
          Positioned(
            // Set the position from the top of the screen
            top: MediaQuery.of(context).size.height * 0.26,
            // Set the position from the left of the screen
            left: MediaQuery.of(context).size.width * 0.29,
            // Set the position from the right of the screen
            right: MediaQuery.of(context).size.width * 0.29,
            // Add the button
            child: ElevatedButton(
              // Define the button's onPressed callback
              onPressed: () {
                // Pop the dialog when the button is pressed
                Navigator.pop(comingSoonDialogContext, false);
              },
              // Define the button's text
              child: Text(
                "Go Back",
                style: TextStyle(
                    fontFamily: "Fontmain",
                    fontSize: 18,
                    color: Colors.white),
              ),
              // Define the button's style
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.05)),
            ),
          ),
        ],
      ),
    );
  }
}
