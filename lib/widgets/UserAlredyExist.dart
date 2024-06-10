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
      child: Stack(
        children: [
          Positioned(
              top: MediaQuery.of(context).size.height * 0.140,// Position from the top of the screen
              left: MediaQuery.of(context).size.width * 0.3,// Position from the left of the screen
              right: MediaQuery.of(context).size.width * 0.3,// Position from the right of the screen
              height: MediaQuery.of(context).size.height * 0.4,// Height of the widget
              // width: MediaQuery.of(context).size.width * 0.02,
              child: 
              // Centers its child widget within itself
              Center(
                // Widget displaying Lottie animation
                child: LottieBuilder.asset(
                  "assets/Animation/already_exist_user.json",// Path to the Lottie animation asset
                  repeat: false,// Animation should not repeat
                  fit: BoxFit.cover,// Box fit strategy for the animation
                  height: 85,// Height of the animation widget
                  width: 85,// Width of the animation widget
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.41,// Position from the top of the screen
            left: MediaQuery.of(context).size.width * 0.1,// Position from the left of the screen
            right: MediaQuery.of(context).size.width * 0.1,// Position from the right of the screen
           // Centers its child widget within itself
            child: Center(
                // Widget for displaying text
                child: Text(
              "Already Registered",// Text content
              // Defines the text style
              style: TextStyle(

                  fontFamily: "Fontmain",// Font family for the text
                  fontSize: 20,// Font size of the text
                  decoration: TextDecoration.none,// No text decoration
                  fontWeight: FontWeight.bold // Bold font weight for the text
                  ),
            )),
          ),
          // User Alredy exist Image here
          Positioned(
              top: MediaQuery.of(context).size.height * 0.19,// Position from the top of the screen
              left: MediaQuery.of(context).size.width * 0.03,// Position from the left of the screen
              right: MediaQuery.of(context).size.width * 0.03,// Position from the right of the screen
              //bottom: MediaQuery.of(context).size.height * 0.39,
              child: Container(
                // color: Colors.blue,
                // Sets the height of the container to 60% of the screen height
                height: MediaQuery.of(context).size.height * 0.6,
                // Sets the width of the container to 50% of the screen width
                width: MediaQuery.of(context).size.width * 0.5,
                // Adds symmetric horizontal padding of 20 pixels
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                 // Centers the child widget within the container
                child: Center(
                   // Text widget to display a message
                  child: Text(
                    "You have not deleted your previous account.Please use another contact number.",
                    textAlign: TextAlign.center,// Center-aligns the text
                    style: TextStyle(
                        fontSize: 15,// Sets the font size to 15
                        color: Color.fromRGBO(0, 123, 224, 1),// Sets the text color
                        decoration: TextDecoration.none // No text decoration
                        ),
                  ),
                ),
              )),
          Positioned(
            // Positions the top of the button at 55% of the screen height
              top: MediaQuery.of(context).size.height * 0.55,
               // Positions the left edge of the button at 10% of the screen width
              left: MediaQuery.of(context).size.width * 0.1,
              // Positions the right edge of the button at 10% of the screen width
              right: MediaQuery.of(context).size.width * 0.1,
              // The child widget that will be positioned
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
                child: Text("Go Back",
                 // Text style
                style: TextStyle(color: Colors.black),),
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
