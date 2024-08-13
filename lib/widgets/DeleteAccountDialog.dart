// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class DeleteAccountDialog extends StatefulWidget {
  // Define variables to hold the callback functions for Yes and No buttons
  var YesButton, NoButton;

  // Constructor for the DeleteAccountDialog widget
  DeleteAccountDialog(
      {super.key, required this.YesButton, required this.NoButton});

  @override
  // Create the state for the DeleteAccountDialog widget
  State<DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState(yesButton: YesButton, noButton: NoButton);
}

// Define the state class for the DeleteAccountDialog widget
class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  // Define variables to hold the callback functions for Yes and No buttons
  var yesButton, noButton;

  // Constructor for the state class, accepting the callback functions for Yes and No buttons
  _DeleteAccountDialogState({required this.yesButton, required this.noButton});

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    return Container(
      // Define margin for the container
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      // Set the height and width of the container
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      // Add a background image to the container
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/App popups/Pop_up ICONS/AppExitBg.webp",
              ),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: LottieBuilder.asset(
              "assets/Animation/Animation - 1711609519678.json",
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Text(
              "Are you sure you want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  wordSpacing: 0.5,
                  fontFamily: "Fontmain",
                  decoration: TextDecoration.none,
                  color: Colors.red,
                  height: 1.5,
                  fontSize: 18),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.01,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Yes button
                ElevatedButton(
                  onPressed: yesButton,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red, width: 5),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.05)),
                ),
                // No button
                ElevatedButton(
                  onPressed: noButton,
                  child: Text("No", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.red, width: 5),
                      backgroundColor: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.05)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
