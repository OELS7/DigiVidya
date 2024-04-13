import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class quiteVideoPlayerDialog extends StatefulWidget {
  var yesButton;
  var noButton;
  quiteVideoPlayerDialog(
      {super.key, required this.yesButton, required this.noButton});

  @override
  State<quiteVideoPlayerDialog> createState() =>
      _quiteVideoPlayerDialogState(yesButton, noButton);
}

class _quiteVideoPlayerDialogState extends State<quiteVideoPlayerDialog> {
  var yesButton;
  var noButton;
  _quiteVideoPlayerDialogState(this.yesButton, this.noButton);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3,bottom: MediaQuery.of(context).size.width* 0.55,left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
      decoration: BoxDecoration(
          //color: Colors.blue,
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height* 0,
            left: MediaQuery.of(context).size.width * 0.32,
           height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width / 10,
              child: LottieBuilder.asset(
              "assets/Animation/Animation - 1711711975948_exit_video.json",
              repeat: false,
              fit: BoxFit.cover,
              height: 140,width: 140,
            )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.150,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Container(
                child: Text(
                  "Are you sure you want to close the video ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Fontmain",
                      fontSize: 19,
                      decoration: TextDecoration.none),
                ),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.254,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: yesButton,
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            fontFamily: "Fontmain", color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3,
                              MediaQuery.of(context).size.height * 0.055)),
                    ),
                    ElevatedButton(
                      onPressed: noButton,
                      child: Text(
                        "No",
                        style: TextStyle(
                            fontFamily: "Fontmain", color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3,
                              MediaQuery.of(context).size.height * 0.055)),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
