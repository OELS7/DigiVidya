import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class InternetErrorDialog extends StatefulWidget {
  var internetErrorDialogContext;
  String message;
  InternetErrorDialog(
      {super.key,
      required this.internetErrorDialogContext,
      required this.message});

  @override
  State<InternetErrorDialog> createState() => _InternetErrorDialogState(
      internetErrorDialogContext: internetErrorDialogContext, message: message);
}

class _InternetErrorDialogState extends State<InternetErrorDialog> {
  var internetErrorDialogContext;
  String message;
  _InternetErrorDialogState(
      {required this.internetErrorDialogContext, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: MediaQuery.of(context).size.height * 0.25),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          // color: Colors.white,
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          // Container(
          //       margin: EdgeInsets.symmetric(vertical: 30),
          //       height: MediaQuery.of(context).size.height * 0.08,
          //       width: MediaQuery.of(context).size.width * 0.2,
          //       decoration: BoxDecoration(
          //           //color: Colors.blue,
          //           image: DecorationImage(
          //               image: AssetImage(
          //                   "assets/App popups/Pop_up ICONS/InternetError.webp"),
          //               fit: BoxFit.fill)),
          //     )
          Positioned(
              top: MediaQuery.of(context).size.height * 0.055,
              left: MediaQuery.of(context).size.width * 0.32,
              //bottom: MediaQuery.of(context).size.width * 0.73,
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.28,
              
              child: LottieBuilder.asset(
                "assets/Animation/internet_error.json",
                height: 140,
                width: 140,
                fit: BoxFit.contain,
                repeat: false,
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.30,
              right: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Internet Error",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.red,
                    fontFamily: "Fontmain",
                    fontSize: 20),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.12,
              right: MediaQuery.of(context).size.width * 0.12,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.5,
                    fontFamily: "Fontmain",
                    decoration: TextDecoration.none,
                    color: Colors.red,
                    height: 1.5,
                    fontSize: 17),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.31,
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
                      Navigator.pop(internetErrorDialogContext);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 18, fontFamily: "Fontmain",color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 3),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.055)),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
