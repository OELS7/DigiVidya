import 'package:digividya/screens/Register.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class userAlreadyExist extends StatefulWidget {
  const userAlreadyExist({super.key});

  @override
  State<userAlreadyExist> createState() => _userAlreadyExistState();
}

class _userAlreadyExistState extends State<userAlreadyExist> {
  @override
  Widget build(BuildContext context) {
    // Container widget to hold the entire UI
    return Container(
      // Setting margin for the container
      margin: EdgeInsets.symmetric(
          // Horizontal margin as a percentage of the screen width
          horizontal: MediaQuery.of(context).size.width * 0.05),
      // Box decoration
      decoration: BoxDecoration(
          // adding the backround image to the container
          image: DecorationImage(
              // Assigning the image.
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      // Stack widget to position children on top of each other
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: LottieBuilder.asset(
              "assets/Animation/already_exist_user.json", // Path to the Lottie animation asset
              height: 60,
              width: 60,
              repeat: false, // Animation should not repeat
              fit: BoxFit.cover, // Box fit strategy for the animation
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.025,),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.04,
            child: Text(
              "Already Registered", // Text content
              // Defines the text style
              style: TextStyle(
                  fontFamily: "Fontmain", // Font family for the text
                  fontSize: 20, // Font size of the text
                  decoration: TextDecoration.none, // No text decoration
                  fontWeight: FontWeight.bold // Bold font weight for the text
                  ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Text(
              "You have not deleted your previous account.Please use another contact number.",
              textAlign: TextAlign.center, // Center-aligns the text
              style: TextStyle(
                  fontSize: 15, // Sets the font size to 15
                  color: Color.fromRGBO(0, 123, 224, 1), // Sets the text color
                  decoration: TextDecoration.none // No text decoration
                  ),
            ),
          ),
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
              child: ElevatedButton(
                // Function to execute when the button is pressed
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      // Creates a route to the Register screen and replaces the current route
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                },
                // The text displayed on the button
                child: Text(
                  "Go Back",
                  // Text style
                  style: TextStyle(color: Colors.black),
                ),
                // Button style customization
                style: ElevatedButton.styleFrom(
                    // fixedSize: Size(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.height * 0.02),
                    // Border color and width
                    side: BorderSide(color: Colors.red, width: 3)),
              ))
        ],
      ),
    );
  }
}
