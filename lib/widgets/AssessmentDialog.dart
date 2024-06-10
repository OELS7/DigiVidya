// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class assessmentDialog extends StatefulWidget {
  // Define variables for the button callbacks
  var playAgainButton;
  var proceedToNextVideo;

  // Constructor for the assessmentDialog widget
  assessmentDialog(
      {super.key,
      required this.playAgainButton,
      required this.proceedToNextVideo});

  @override
  // Create the state for the assessmentDialog widget
  State<assessmentDialog> createState() =>
      _assessmentDialogState(playAgainButton, proceedToNextVideo);
}

// Define the state class for the assessmentDialog widget
class _assessmentDialogState extends State<assessmentDialog> {
  // Define variables to store the button callbacks
  var playAgainButton;
  var proceedToNextVideo;

  // Constructor for the state class, accepting button callbacks
  _assessmentDialogState(this.playAgainButton, this.proceedToNextVideo);

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    // Enable wakelock to keep the screen on
    WakelockPlus.enable();
    return Container(
      // Define margin for the container
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      // Add a background image to the container
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      child: Stack(
        children: [
          // Position the text within the stack
          Positioned(
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                // Add margin to the text container
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  "Try again / Next ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Fontmain",
                      decoration: TextDecoration.none,
                      fontSize: 25,
                      color: Colors.black),
                ),
              )),
          // Position the button container within the stack
          Positioned(
              top: MediaQuery.of(context).size.height * 0.11,
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: Container(
                // Set the height and width for the button container
                height: MediaQuery.of(context).size.height * 0.179,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Define the first button for playing again
                    ElevatedButton(
                      onPressed: playAgainButton, // Set the callback function
                      child: Text(
                        "Play again",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Fontmain", color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(33, 117, 187, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                              MediaQuery.of(context).size.height * 0.07)),
                    ),
                    // Define the second button for proceeding to the next video
                    ElevatedButton(
                      onPressed: proceedToNextVideo, // Set the callback function
                      child: Text(
                        "Proceed to next ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Fontmain", color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(1, 157, 143, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                              MediaQuery.of(context).size.height * 0.07)),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
