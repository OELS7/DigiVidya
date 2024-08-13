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
      {super.key,
      required this.internetErrorDialogContext,
      required this.message});

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
      margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25,
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
      
      // Add background decoration with an image
      decoration: BoxDecoration(
        // color: Colors.blueGrey,
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

              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.025,
          
            child: Text(
              "Internet Error",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.red,
                  fontFamily: "Fontmain",
                  fontSize: 20),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: MediaQuery.sizeOf(context).width * 0.75,
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
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
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
            ),
          )
        ],
      ),
    );
  }
}
