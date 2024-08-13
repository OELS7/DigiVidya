import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubmittingfIndecator extends StatefulWidget {
  const SubmittingfIndecator({super.key});

  @override
  State<SubmittingfIndecator> createState() => _SubmittingfIndecatorState();
}

class _SubmittingfIndecatorState extends State<SubmittingfIndecator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height *
              0.35, // Margin from the top of the screen
          bottom: MediaQuery.of(context).size.height *
              0.35, // Margin from the bottom of the screen
          left: MediaQuery.of(context).size.width *
              0.05, // Margin from the left of the screen
          right: MediaQuery.of(context).size.width *
              0.05 // Margin from the right of the screen
          ),
      decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.only(
              // Defines border radius for rounded corners
              topLeft: Radius.circular(30), // Top-left corner radius
              topRight: Radius.circular(30), // Top-right corner radius
              bottomLeft: Radius.circular(30), // Bottom-left corner radius
              bottomRight: Radius.circular(30) // Bottom-right corner radius
              )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Displaying animation using Lottie
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              child: LottieBuilder.asset(
                // Asset path for the animation
                "assets/Animation/Animation - 1710389401962.json",
                height: 150, // Height of the animation
                width: 250, // Width of the animation
              )),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
            child: Text(
              "Submitting Request", // Text displayed in the center
              style: TextStyle(
                  fontSize: 25, // Font size of the text
                  color: Colors.black, // Text color
                  decoration: TextDecoration.none, // No text decoration
                  fontFamily: "Fontmain" // Font family of the text
                  ),
            ),
          )
        ],
      ),
    );
  }
}
