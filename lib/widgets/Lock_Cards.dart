import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class lockcard extends StatefulWidget {
  var LockCardDialogContext;
  lockcard({super.key, required this.LockCardDialogContext});

  @override
  State<lockcard> createState() => _lockcardState(LockCardDialogContext);
}

class _lockcardState extends State<lockcard> {
  var LockCardDialogContext;
  _lockcardState(this.LockCardDialogContext);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: MediaQuery.of(context).size.height * 0.3),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      child: Stack(
        children: [
          //For icon
          Positioned(
              child: Container(
            // color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 118, vertical: 0.03),
            width: MediaQuery.of(context).size.height * 0.12,
            height: MediaQuery.of(context).size.height * 0.13,
            child: LottieBuilder.asset(
                repeat: false,
                // width: 8.0,
                // height: 1,
                fit: BoxFit.cover,
                "assets/Animation/Animation - 1711687280301_lock_card.json"),
          )),

          //For Description
          Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                maxLines: 5,
                softWrap: true,
                "To learn more,delete your 'Guest' account and register as a DigiVidya user.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  //fontWeight: ,
                  fontFamily: "Fontmain",
                  decoration: TextDecoration.none,
                  height: 1.5,
                ),
              )),
          //For Button
          Positioned(
              top: MediaQuery.of(context).size.height * 0.26,
              left: MediaQuery.of(context).size.width * 0.29,
              right: MediaQuery.of(context).size.width * 0.29,
              child: ElevatedButton(
                onPressed: () {
                  print("pressed back");
                  Navigator.pop(LockCardDialogContext, false);
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                      fontFamily: "Fontmain",
                      fontSize: 18,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.05)),
              )),
        ],
      ),
    );
  }
}
