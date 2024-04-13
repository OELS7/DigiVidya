import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    return SafeArea(
      child: Container(
        
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25,bottom: MediaQuery.of(context).size.height * 0.3,left: MediaQuery.of(context).size.width * 0.05,right: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(
          //color: Colors.blue,
            image: DecorationImage(
                image:
                    AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
        child: Stack(
          children: [
            //Assessment image
            Positioned(
                top: MediaQuery.of(context).size.height * 0,
                left: MediaQuery.of(context).size.width * 0.318,
                height: MediaQuery.of(context).size.height * 0.11,
                width:MediaQuery.of(context).size.width * 0.02,
                child: LottieBuilder.asset(
                    "assets/Animation/Animation - 1711711975948_exit_video.json",
                    repeat: false,
                    fit: BoxFit.cover,
                    height: 140,width: 140,
                  )),
            //Aleart Description
            Positioned(
                top: MediaQuery.of(context).size.height * 0.14,
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Text(
                  "Are you sure you want to leave Assignment ?",
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
      ),
    );
  }
}
