import 'package:flutter/material.dart';

// ignore: must_be_immutable
class commingSoonAlertbox extends StatefulWidget {
  var comingSoonDialogContext;
  commingSoonAlertbox({super.key, required this.comingSoonDialogContext});

  @override
  State<commingSoonAlertbox> createState() =>
      _commingSoonAlertboxState(comingSoonDialogContext);
}

class _commingSoonAlertboxState extends State<commingSoonAlertbox> {
  var comingSoonDialogContext;
  _commingSoonAlertboxState(this.comingSoonDialogContext);

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
            margin: EdgeInsets.symmetric(horizontal: 120, vertical: 39),
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/App popups/Pop_up ICONS/ComingSoonIcon.webp"))),
          )),

          //For Description
          Positioned(
              top: MediaQuery.of(context).size.height * 0.185,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                "This section will be publish shortly.",
                textAlign: TextAlign.start,
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
                  Navigator.pop(comingSoonDialogContext, false);
                },
                child: Text(
                  "Go Back",
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
