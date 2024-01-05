import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class LikeDialog extends StatefulWidget {
  var yesButton;
  var noButton;
  LikeDialog({super.key, required this.yesButton, required this.noButton});

  @override
  State<LikeDialog> createState() => _LikeDialogState(yesButton, noButton);
}

class _LikeDialogState extends State<LikeDialog> {
  var yesButton;
  var noButton;
  _LikeDialogState(this.yesButton, this.noButton);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.27),
      decoration: BoxDecoration(
          //color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          //For Like icon
          Positioned(
              left: MediaQuery.of(context).size.width * 0.29,
              right: MediaQuery.of(context).size.width * 0.29,
              child: GestureDetector(
                onTap: yesButton,
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.002),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: SvgPicture.asset(
                    "assets/App popups/Pop_up ICONS/like.svg",
                  ),
                ),
              )),

          Positioned(
              top: MediaQuery.of(context).size.height * 0.165,
              left: MediaQuery.of(context).size.width * 0.11,
              right: MediaQuery.of(context).size.width * 0.11,
              child: Text(
                "Tap on heart to like this video.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Fontmain",
                    fontSize: 19,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.269,
              left: MediaQuery.of(context).size.width * 0.47,
              right: MediaQuery.of(context).size.width * 0.08,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: noButton,
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              fontFamily: "Fontmain",
                              fontSize: 19,
                              decoration: TextDecoration.none,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
