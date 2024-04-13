
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class internalServerError extends StatefulWidget {
  var internalServerErrorContext;
  String ErrorTitle;
  String description;
  var retryButton;
  String ButtonText;
  internalServerError(
      {super.key,
      required this.internalServerErrorContext,
      required this.ErrorTitle,
      required this.description,
      required this.retryButton,
      required this.ButtonText});

  @override
  State<internalServerError> createState() => _internalServerErrorState(
      internalServerErrorContex: internalServerErrorContext,
      ErrorTitle: ErrorTitle,
      Description: description,
      reTryButton: retryButton,
      ButtonText: ButtonText);
}

class _internalServerErrorState extends State<internalServerError> {
  var internalServerErrorContex;
  String ErrorTitle;
  String Description;
  String ButtonText;
  var reTryButton;
  _internalServerErrorState(
      {required this.internalServerErrorContex,
      required this.ErrorTitle,
      required this.Description,
      required this.reTryButton,
      required this.ButtonText});

  //   decoration: BoxDecoration(
  // image: DecorationImage(
  //     image: AssetImage(
  //         "assets/App popups/Pop_up ICONS/InternetError.webp")))

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: MediaQuery.of(context).size.height * 0.25),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          Positioned(
              left: MediaQuery.of(context).size.width * 0.25,
              bottom: MediaQuery.of(context).size.height *0.36,
              child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.104),
            height: MediaQuery.of(context).size.height * 0.08,
            child: LottieBuilder.asset(
              "assets/Animation/Animation - 1711601885547.json",
              height: 140,
              width: 140,
              fit: BoxFit.contain,
              repeat: false,
            ),
          )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.159,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                child: Center(
                  child: Text(
                    ErrorTitle,
                    style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.none,
                        fontFamily: "mainFont"),
                  ),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.195,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  Description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 15,
                      fontFamily: "mainFont",
                      decoration: TextDecoration.none),
                )),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.29,
              left: MediaQuery.of(context).size.width * 0.3,
              right: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: reTryButton,
                child: Text(ButtonText, style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red.shade900, width: 2.5)),
              ))
        ],
      ),
    );
  }
}
