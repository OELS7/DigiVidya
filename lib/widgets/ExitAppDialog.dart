// Import necessary Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class exitAppDialog extends StatefulWidget {
  // Variable to hold the context of the dialog
  var dialogcontect;

  // Constructor for the exitAppDialog widget
  exitAppDialog({super.key, required this.dialogcontect});

  @override
  // Create the state for the exitAppDialog widget
  State<exitAppDialog> createState() => _exitAppDialogState(dialogcontect);
}

class _exitAppDialogState extends State<exitAppDialog> {
  // Variable to hold the context of the dialog
  var dialogcontect;

  // Constructor for the state of the exitAppDialog widget
  _exitAppDialogState(this.dialogcontect);

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    // Return a container with a specific layout
    return Container(
      // Set margin for the container
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.2),
      // Set background decoration with an image
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
            height: MediaQuery.sizeOf(context).height * 0.07,
            child: LottieBuilder.asset(
              "assets/Animation/SnnE6DJDpc.json",
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.01,),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05,child: Text(
                "Exit App",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Fontmain",
                    fontSize: 20),
              ),),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.07,child: Text(
                "Are you sure you want to leave the application?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.5,
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18),
              ),),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.116,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // "Yes" button
                  ElevatedButton(
                    onPressed: () {
                      // Delay for 600 milliseconds before exiting the app
                      Future.delayed(
                        Duration(milliseconds: 600),
                        () {
                          exit(0); // Exit the app
                        },
                      );
                      Navigator.pop(dialogcontect); // Close the dialog
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Fontmain",
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.055)),
                  ),
                  // "No" button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogcontect, false); // Close the dialog without exiting the app
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Fontmain",
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.055)),
                  )
                ],
              ),)
        ],
      ),
    );
  }
}
