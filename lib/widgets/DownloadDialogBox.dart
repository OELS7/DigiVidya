import 'package:flutter/material.dart';

// ignore: must_be_immutable
class downloadDialogBox extends StatelessWidget {
  String dialogTitle = "";
  ValueNotifier<double> progress;

  // bool isPause = false;
  downloadDialogBox({
    super.key,
    required this.dialogTitle,
    required this.progress,
  });

  // ValueNotifier<double> progress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: progress,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).size.height * 0.3),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 120, vertical: 35),
                height: MediaQuery.of(context).size.height * 0.066,
                decoration: BoxDecoration(
                    //color: Colors.blue,
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/App popups/Pop_up ICONS/DownloadIcon.webp"))),
              )),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.13,
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.180,
                  child: Text(
                    "Downloading...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: "Fontmain"),
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 10,
                      value: value,
                      color: Colors.blue.shade900,
                    ),
                    Text(
                      "${(value * 100).round()}%",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Fontmain",
                          fontSize: 20,
                          color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
