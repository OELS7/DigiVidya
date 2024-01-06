import 'package:flutter/material.dart';

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
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          Positioned(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/App popups/Pop_up ICONS/VideoPlayerIcon.webp"))),
          )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.135,
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
              top: MediaQuery.of(context).size.height * 0.24,
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
