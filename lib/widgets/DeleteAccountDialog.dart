import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class DeleteAccountDialog extends StatefulWidget {
  var YesButton, NoButton;

  DeleteAccountDialog(
      {super.key, required this.YesButton, required this.NoButton});

  @override
  State<DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState(yesButton: YesButton, noButton: NoButton);
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  var yesButton, noButton;
  _DeleteAccountDialogState({required this.yesButton, required this.noButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.3),
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
          // color: Colors.red,
          image: DecorationImage(
              image: AssetImage(
                "assets/App popups/Pop_up ICONS/AppExitBg.webp",
              ),
              fit: BoxFit.fill)),
      child: Stack(children: [
        // Container(
        //   margin: EdgeInsets.symmetric(
        //       vertical: MediaQuery.of(context).size.height * 0.023),9
        //   height: MediaQuery.of(context).size.height * 0.06,
        //   decoration: BoxDecoration(
        //       //color: Colors.blue,
        //       image: DecorationImage(
        //           image: AssetImage(
        //               "assets/App popups/Pop_up ICONS/AlertIcon.webp"))),
        // )
        Positioned(
            top: MediaQuery.of(context).size.height * 0.02,
            height: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.33,
            child: LottieBuilder.asset(
              "assets/Animation/Animation - 1711609519678.json",
              height:80,
              width:80,
              fit: BoxFit.cover,
              repeat: true              ,
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.16,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              "Are you sure you want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  wordSpacing: 0.5,
                  fontFamily: "Fontmain",
                  decoration: TextDecoration.none,
                  color: Colors.red,
                  height: 1.5,
                  fontSize: 18),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0.0,
            right: 0.0,
            bottom: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: yesButton,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red, width: 5),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.05)),
                ),
                ElevatedButton(
                  onPressed: noButton,
                  child: Text("No", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.red, width: 5),
                      backgroundColor: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                          MediaQuery.of(context).size.height * 0.05)),
                )
              ],
            ))
      ]),
    );
  }
}
