import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class quiteVideoPlayerDialog extends StatefulWidget {
  // Declare variable to hold the callback function for the 'Yes' button
  var yesButton;
  // Declare variable to hold the callback function for the 'No' button
  var noButton;
  // Constructor for the 'quiteVideoPlayerDialog' class
  quiteVideoPlayerDialog(
      {
      // Call the superclass constructor with optional key parameter
      super.key, 
      // Required parameter: callback function for the 'Yes' button
      required this.yesButton, 
      // Required parameter: callback function for the 'No' button
      required this.noButton});

  // Override the createState method to create an instance of the state class
  @override
  State<quiteVideoPlayerDialog> createState() =>
   // Return an instance of the state class _quiteVideoPlayerDialogState
      _quiteVideoPlayerDialogState(yesButton, noButton);
}

class _quiteVideoPlayerDialogState extends State<quiteVideoPlayerDialog> {
  // Declare variables to hold callback functions for the "Yes" and "No" buttons
  var yesButton;
  var noButton;
  // Constructor for the _quiteVideoPlayerDialogState class
  _quiteVideoPlayerDialogState(this.yesButton, this.noButton);

  @override
  Widget build(BuildContext context) {
    // Container widget to hold the dialog content
    return Container(
       // Margin for the container
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3,bottom: MediaQuery.of(context).size.width* 0.55,left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
      // Decoration for the container
      decoration: BoxDecoration(
          //color: Colors.blue,
          // Background image for the container
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      // Child widget stack to overlay multiple children
      child: Stack(
        children: [
           // Positioned widget for the exit animation
          Positioned(
            top: MediaQuery.of(context).size.height* 0,
            left: MediaQuery.of(context).size.width * 0.32,
           height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width / 10,
              child: LottieBuilder.asset(
                 // Animation asset for exit video animation
              "assets/Animation/Animation - 1711711975948_exit_video.json",
              repeat: false,
              fit: BoxFit.cover,
              height: 140,width: 140,
            )),
          // Positioned widget for the dialog message
          Positioned(
              top: MediaQuery.of(context).size.height * 0.150,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Container(
                // Dialog message text
                child: Text(
                  
                  "Are you sure you want to close the video ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Fontmain",
                      fontSize: 19,
                      decoration: TextDecoration.none),
                ),
              )),
          // Positioned widget for the "Yes" and "No" buttons
          Positioned(
              top: MediaQuery.of(context).size.height * 0.254,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Elevated button for "Yes" option
                    ElevatedButton(
                      onPressed: yesButton,// onPressed callback function for the "Yes" button
                      child: Text(
                        "Yes",// Text displayed on the button
                        style: TextStyle(
                            fontFamily: "Fontmain", // Font family for the text
                             color: Colors.white // Text color
                             ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900, // Background color of the button
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30) // Border radius of the button
                              ),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3,// Width of the button
                              MediaQuery.of(context).size.height * 0.055 // Height of the button
                              )),
                    ),
                    // Elevated button for "No" option
                    ElevatedButton(
                      onPressed: noButton ,// onPressed callback function for the "No" button,
                      child: Text(
                        "No" ,// Text displayed on the button
                        style: TextStyle(
                            fontFamily: "Fontmain",// Font family for the text
                             color: Colors.white // Text color
                             ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,// Background color of the button
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),// Border radius of the button
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, // Width of the button
                              MediaQuery.of(context).size.height * 0.055 // Height of the button
                              )),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
