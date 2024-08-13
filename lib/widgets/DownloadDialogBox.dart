// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class downloadDialogBox extends StatelessWidget {
  // Define a string variable to hold the dialog title
  String dialogTitle = "";

  // Define a ValueNotifier to track download progress
  ValueNotifier<double> progress;

  // Constructor for the downloadDialogBox widget
  downloadDialogBox({
    super.key,
    required this.dialogTitle, // Initialize dialogTitle
    required this.progress, // Initialize progress
  });

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to listen to changes in progress
    return ValueListenableBuilder(
      valueListenable: progress,
      builder: (context, value, child) {
        // Return a container with a specific layout
        return Container(
          // Set margin for the container
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.28),
          // Set background decoration with an image
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
          // Use a Stack to position child widgets
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               LottieBuilder.asset(
                  "assets/Animation/download.json",
                  fit: BoxFit.cover,
                  repeat: true,
                  height: 100,
                  width: 100,
                ),
              
              SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                  child: Text(
                    "Downloading...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: "Fontmain"),
                  )),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.04,
                    ),
                    // Linear progress indicator
                    LinearProgressIndicator(
                        minHeight: 10,
                        value: value,
                        color: const Color.fromRGBO(33, 117, 187, 1)),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    // Text showing the download percentage
                    Text(
                      "${(value * 100).round()}%",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Fontmain",
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
