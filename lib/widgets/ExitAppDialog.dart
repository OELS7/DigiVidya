import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class exitAppDialog extends StatefulWidget {
  var dialogcontect;
  exitAppDialog({super.key, required this.dialogcontect});

  @override
  State<exitAppDialog> createState() => _exitAppDialogState(dialogcontect);
}

class _exitAppDialogState extends State<exitAppDialog> {
  var dialogcontect;
  _exitAppDialogState(this.dialogcontect);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
          // color: Colors.blue,
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 15),
          //   height: MediaQuery.of(context).size.height * 0.06,
          //   decoration: BoxDecoration(
          //       //color: Colors.blue,
          //       image: DecorationImage(
          //           image: AssetImage(
          //               "assets/App popups/Pop_up ICONS/AlertIcon.webp"))),
          // )
          Positioned(
              height: MediaQuery.of(context).size.height * 0.11,
              left: MediaQuery.of(context).size.width * 0.32,
              child: LottieBuilder.asset(
                "assets/Animation/SnnE6DJDpc.json",
                fit: BoxFit.cover,
                repeat: false,
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.115,
              left: MediaQuery.of(context).size.width * 0.35,
              right: MediaQuery.of(context).size.width * 0.28,
              child: Text(
                "Exit App",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Fontmain",
                    fontSize: 20),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              child: Text(
                "Are you sure you want to leave the application ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.5,
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.239,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(
                        Duration(milliseconds: 600),
                        () {
                          exit(0);
                        },
                      );
                      Navigator.pop(dialogcontect);
                    },
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
                    onPressed: () {
                      Navigator.pop(dialogcontect, false);
                    },
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
