import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// ignore: must_be_immutable
class assessmentDialog extends StatefulWidget {
  var playAgainButton;
  var proceedToNextVideo;
  assessmentDialog(
      {super.key,
      required this.playAgainButton,
      required this.proceedToNextVideo});

  @override
  State<assessmentDialog> createState() =>
      _assessmentDialogState(playAgainButton, proceedToNextVideo);
}

class _assessmentDialogState extends State<assessmentDialog> {
  var playAgainButton;
  var proceedToNextVideo;
  _assessmentDialogState(this.playAgainButton, this.proceedToNextVideo);

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      child: Stack(children: [
        Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Text(
                "Try again / Next ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    fontSize: 25,
                    color: Colors.black),
              ),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.11,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.179,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: playAgainButton,
                    child: Text(
                      "Play again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Fontmain", color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(33, 117, 187, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.07)),
                  ),
                  ElevatedButton(
                    onPressed: proceedToNextVideo,
                    child: Text(
                      "Proceed to next ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Fontmain", color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 157, 143, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.07)),
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
