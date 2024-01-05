import 'package:flutter/material.dart';

// ignore: must_be_immutable
class exitAssessment extends StatefulWidget {
  var yesButtonFuntion;
  var noButtonFunction;
  exitAssessment(
      {super.key,
      required this.yesButtonFuntion,
      required this.noButtonFunction});

  @override
  State<exitAssessment> createState() => _exitAssessmentState(
      yesButtonFuntion: yesButtonFuntion, noButtonFunction: noButtonFunction);
}

class _exitAssessmentState extends State<exitAssessment> {
  var yesButtonFuntion, noButtonFunction;
  _exitAssessmentState(
      {required this.yesButtonFuntion, required this.noButtonFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          //Assessment image
          Positioned(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.125,
            decoration: BoxDecoration(
                //color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage(
                        "assets/App popups/Pop_up ICONS/assessment.webp"))),
          )),
          //Aleart Description
          Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Text(
                "Are you sure you want to leave Assessment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.5,
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18),
              )),
          //Buttons
          Positioned(
              top: MediaQuery.of(context).size.height * 0.24,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: yesButtonFuntion,
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
                  ElevatedButton(
                    onPressed: noButtonFunction,
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
              ))
        ],
      ),
    );
  }
}
