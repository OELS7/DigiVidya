import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.2),
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          Positioned(
              child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.104),
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/App popups/Pop_up ICONS/InternetError.webp"))),
          )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
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
            top: MediaQuery.of(context).size.height * 0.235,
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
              top: MediaQuery.of(context).size.height * 0.36,
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
