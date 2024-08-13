import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikeDialog extends StatefulWidget {
  // Defining the variable for buttons
  var yesButton; // this is for yes button
  var noButton; // this is for no button

// A ValueNotifier to track the state of the heart button (pressed or not)
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);

// Constructor for the LikeDialog class
  LikeDialog({
    super.key, // Pass the key to the superclass constructor
    required this.yesButton, // Required parameter for the "Yes" button action
    required this.noButton, // Required parameter for the "No" button action
    required this.heartButtonPressed, // Required parameter to pass the state of the heart button
  });

// Override the createState method to create the mutable state for this widget
  @override
  State<LikeDialog> createState() =>
      // Create an instance of _LikeDialogState, passing the required parameters
      _LikeDialogState(yesButton, noButton, heartButtonPressed);
}

class _LikeDialogState extends State<LikeDialog> with TickerProviderStateMixin {
// Declare a variable to store the yesButton callback
  var yesButton;

// Declare a variable to store the noButton callback
  var noButton;

// Create a ValueNotifier to track the state of the heart button (pressed or not)
// Initialize it with false, meaning the heart button is not pressed initially
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);

// Constructor for the _LikeDialogState class
// Takes three parameters: yesButton, noButton, and heartButtonPressed
  _LikeDialogState(this.yesButton, this.noButton, this.heartButtonPressed);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// Override the build method to describe how to display the widget
  @override
  Widget build(BuildContext context) {
    // Return a Container widget as the root of this part of the widget tree
    return Container(
      // Add margin around the container
      margin: EdgeInsets.symmetric(
          horizontal: 20, // Horizontal margin of 20 pixels
          vertical: MediaQuery.of(context).size.height *
              0.27 // Vertical margin relative to screen height
          ),
      // Decorate the container
      decoration: BoxDecoration(
          // Optional background color (commented out)
          //color: Colors.blue,
          // Add a background image to the container
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/AppExitBg.webp") // Path to the background image
              )),
      // Use a Stack to layer widgets on top of each other
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            // Set the onTap callback to the yesButton function
            onTap: yesButton,
            // Use a Container to hold the icon
            child: Container(
              // Set the height of the container relative to the screen height
              height: MediaQuery.of(context).size.height * 0.12,
              // Set the width of the container relative to the screen width
              width: MediaQuery.of(context).size.width * 0.3,
              // Optional background color (commented out)
              // color: Colors.green,
              // Use ValueListenableBuilder to listen to changes in heartButtonPressed
              child: ValueListenableBuilder(
                // Set the valueListenable to heartButtonPressed
                valueListenable: heartButtonPressed,
                // Build the widget tree based on the current value of heartButtonPressed
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    // Set the duration of the animation
                    duration: Duration(milliseconds: 300),
                    // Switch between two icons based on the value of heartButtonPressed
                    child: value
                        ? Icon(
                            Icons.favorite, // Filled heart icon
                            color: const Color.fromRGBO(
                                183, 28, 28, 1), // Red color
                            size: 80, // Size of the icon
                          )
                        : Icon(
                            Icons.favorite_border, // Outlined heart icon
                            color: const Color.fromRGBO(
                                183, 28, 28, 1), // Red color
                            size: 80, // Size of the icon
                          ),
                  );
                },
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.06,
            child: Text(
              "Tap on heart to like this video.", // Instruction text
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                  fontFamily: "Fontmain", // Custom font
                  fontSize: 19, // Font size
                  color: Colors.black, // Text color
                  decoration: TextDecoration.none // No text decoration
                  ),
            ),
          ),
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.06,
              child: Container(
                // Set the height of the container relative to the screen height
                height: MediaQuery.of(context).size.height * 0.05,
                // Set the width of the container relative to the screen width
                width: MediaQuery.of(context).size.width * 0.3,
                // Decorate the container
                decoration: BoxDecoration(
                    color: Colors.red.shade900, // Red background color
                    borderRadius: BorderRadius.only(
                        // Rounded corners
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                // Center the child widgets inside the container
                child: Center(
                  // Use a Row to arrange the child widgets horizontally
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center-align the children
                    crossAxisAlignment: CrossAxisAlignment
                        .end, // Align the children at the end of the container
                    children: [
                      // Use GestureDetector to detect taps on the Skip button
                      GestureDetector(
                        // Set the onTap callback to the noButton function
                        onTap: noButton,
                        // Display the Skip text
                        child: Text(
                          "Skip", // Skip button text
                          style: TextStyle(
                              fontFamily: "Fontmain", // Custom font
                              fontSize: 19, // Font size
                              decoration:
                                  TextDecoration.none, // No text decoration
                              color: Colors.white // Text color
                              ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
