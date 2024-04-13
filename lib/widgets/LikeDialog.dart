import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class LikeDialog extends StatefulWidget {
  var yesButton;
  var noButton;
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);
  LikeDialog(
      {super.key,
      required this.yesButton,
      required this.noButton,
      required this.heartButtonPressed});

  @override
  State<LikeDialog> createState() =>
      _LikeDialogState(yesButton, noButton, heartButtonPressed);
}

class _LikeDialogState extends State<LikeDialog> with TickerProviderStateMixin {
  var yesButton;
  var noButton;
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);

  _LikeDialogState(this.yesButton, this.noButton, this.heartButtonPressed);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.27),
      decoration: BoxDecoration(
          //color: Colors.blue,
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
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
                  // color: Colors.green,
                  child: ValueListenableBuilder(
                    valueListenable: heartButtonPressed,
                    builder: (context, value, child) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: value
                            ? Icon(
                                Icons.favorite,
                                color: const Color.fromRGBO(183, 28, 28, 1),
                                size: 80,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: const Color.fromRGBO(183, 28, 28, 1),
                                size: 80,
                              ),
                      );
                    },
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
