import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class lockcard extends StatefulWidget {
  // Declare a variable to hold the context of the LockCardDialog
  var LockCardDialogContext;
    // Use the key parameter and a required named parameter for LockCardDialogContext in the constructor
  lockcard({super.key, required this.LockCardDialogContext});

  // Override createState to create the state object for this widget
  @override
  State<lockcard> createState() => _lockcardState(LockCardDialogContext);
}


// Define a class for the lockcard widget, extending a StatefulWidget
class _lockcardState extends State<lockcard> {
  // Declare a variable to hold the context of the LockCardDialog in the state class
  var LockCardDialogContext;
  // Define a constructor for the state class to initialize LockCardDialogContext
  _lockcardState(this.LockCardDialogContext);
  @override
  Widget build(BuildContext context) {
    // Container widget to hold the entire UI
    return Container(
      // Setting margin for the container
      margin: EdgeInsets.symmetric(
        // Horizontal margin
          horizontal: 15, 
          // Vertical margin as a percentage of the screen height
          vertical: MediaQuery.of(context).size.height * 0.3),
      // Vertical margin as a percentage of the screen height
      decoration: BoxDecoration(
          image: DecorationImage(
            // AssetImage to load the image from assets
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      // Stack widget to position children on top of each other
      child: Stack(
        children: [
          // Positioned widget to place the icon
          Positioned(
            // Container to hold the Lottie animation
              child: Container(
            // color: Colors.black,
            // Setting margin for the container
            margin: EdgeInsets.symmetric(
              // Horizontal margin
              horizontal: 118, 
              // Vertical margin
              vertical: 0.03),
            // Setting the width of the container
            width: MediaQuery.of(context).size.height * 0.12,
             // Setting the height of the container
            height: MediaQuery.of(context).size.height * 0.13,
              // Lottie animation for the icon
            child: LottieBuilder.asset(
                // Lottie animation for the icon
                repeat: false,
                // width: 8.0,
                // height: 1,
                 // Fit the animation to the container
                fit: BoxFit.cover,
                // Path to the Lottie animation file
                "assets/Animation/Animation - 1711687280301_lock_card.json"),
          )),

          // Positioned widget to place the description text
          Positioned(
            // Position from the top as a percentage of the screen height
              top: MediaQuery.of(context).size.height * 0.14,
              // Position from the left as a percentage of the screen width
              left: MediaQuery.of(context).size.width * 0.1,
              // Position from the right as a percentage of the screen width
              right: MediaQuery.of(context).size.width * 0.1,
              // Child widget to display the text
              child: Text(
                // Maximum number of lines for the text
                maxLines: 5,
                // Enable soft wrapping of the text
                softWrap: true,
                // The actual text to be displayed
                "To learn more,delete your 'Guest' account and register as a DigiVidya user.",
                 // Align the text to the center
                textAlign: TextAlign.center,
                // Style the text
                style: TextStyle(
                  // Font size of the text
                  fontSize: 16,
                  // Color of the text
                  color: Colors.black,
                   // Font family of the text
                  fontFamily: "Fontmain",
                  // Remove any text decoration
                  decoration: TextDecoration.none,
                  // Line height of the text
                  height: 1.5,
                ),
              )),


          // Positioned widget to place the button at a specific position
          Positioned(
               // Position from the top as a percentage of the screen height
              top: MediaQuery.of(context).size.height * 0.26,
              // Position from the left as a percentage of the screen width
              left: MediaQuery.of(context).size.width * 0.29,
              // Position from the right as a percentage of the screen width
              right: MediaQuery.of(context).size.width * 0.29,
              // Child widget to display the button
              child: ElevatedButton(
                // onPressed callback for the button
                onPressed: () {
                  // Print a message to the console when the button is pressed
                  print("pressed back");
                  // Close the dialog and return false
                  Navigator.pop(LockCardDialogContext, false);
                },
                // Child widget to display the text on the button
                child: Text(
                  // Text to be displayed on the button
                  "Back",
                   // Style the text
                  style: TextStyle(
                    // Font family of the text
                      fontFamily: "Fontmain",
                      // Font size of the text
                      fontSize: 18,
                      // Color of the text
                      color: Colors.white),
                ),
                 // Style the ElevatedButton
                style: ElevatedButton.styleFrom(
                     // Background color of the button
                    backgroundColor: Colors.blue.shade600,
                    // Shape of the button
                    shape: RoundedRectangleBorder(
                        // Border radius of the button
                        borderRadius: BorderRadius.circular(30)),
                    // Fixed size of the button
                    fixedSize: Size(
                      // Width of the button as a percentage of the screen width
                      MediaQuery.of(context).size.width * 0.25,
                      // Height of the button as a percentage of the screen height
                      MediaQuery.of(context).size.height * 0.05)),
              )),
        ],
      ),
    );
  }
}
