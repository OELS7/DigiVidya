// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Ignore the must_be_immutable lint rule for this widget
// ignore: must_be_immutable
class commingSoonAlertbox extends StatefulWidget {
  // Define a variable to hold the dialog context
  var comingSoonDialogContext;

  // Constructor for the commingSoonAlertbox widget
  commingSoonAlertbox({super.key, required this.comingSoonDialogContext});

  @override
  // Create the state for the commingSoonAlertbox widget
  State<commingSoonAlertbox> createState() =>
      _commingSoonAlertboxState(comingSoonDialogContext);
}

// Define the state class for the commingSoonAlertbox widget
class _commingSoonAlertboxState extends State<commingSoonAlertbox> {
  // Define a variable to hold the dialog context
  var comingSoonDialogContext;

  // Constructor for the state class, accepting the dialog context
  _commingSoonAlertboxState(this.comingSoonDialogContext);

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.amberAccent,
      height: MediaQuery.of(context).size.height * 0.50,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,vertical:MediaQuery.sizeOf(context).height * 0.32),
      // Add a background image to the container
      decoration: BoxDecoration(
       // color: Colors.blueGrey,
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp",),),),
      child: LayoutBuilder(builder: (context, constraints) {
         double parentHeight = constraints.maxHeight;
         double parentWidth = constraints.maxWidth;
        return Container(
          height: parentHeight *0.30,
          width: parentWidth,
         // color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.12,
                child: LottieBuilder.asset(
                  "assets/Animation/Animation - 1711598825358.json",
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),

              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.09,
                width: MediaQuery.sizeOf(context).width * 0.75,
                child: Text("This section will be published shortly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "Fontmain",
                      decoration: TextDecoration.none,
                      height: 1.5,
                    )),
              ),
              
              SizedBox(
                 height: MediaQuery.sizeOf(context).height * 0.05,
                child: ElevatedButton(
                  // Define the button's onPressed callback
                  onPressed: () {
                    // Pop the dialog when the button is pressed
                    Navigator.pop(comingSoonDialogContext, false);
                  },
                  // Define the button's text
                  child: Text(
                    "Go Back",
                    style: TextStyle(
                        fontFamily: "Fontmain", fontSize: 18, color: Colors.white),
                  ),
                  // Define the button's style
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        );
      },),
    );
  }
}
