import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class CustomAlertForPermission extends StatefulWidget {
  var OpenApp;
  CustomAlertForPermission({super.key, required this.OpenApp});

  @override
  State<CustomAlertForPermission> createState() =>
      _CustomAlertForPermissionState(OpenAppsetting: OpenApp);
}

class _CustomAlertForPermissionState extends State<CustomAlertForPermission> {
  var OpenAppsetting;
  _CustomAlertForPermissionState({required this.OpenAppsetting});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          // width: MediaQuery.of(context).size.width * 0.2,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.35,
              bottom: MediaQuery.of(context).size.height * 0.35,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/App popups/Pop_up ICONS/AppExitBg.webp",
                  ),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          // padding: EdgeInsets.all(10),

          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Permission Setting",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "You have denied the Gallary permission , you have to enable manually in app setting.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                    onPressed: OpenAppsetting, child: Text("Open App Setting")),
              ]),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.29,
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.25,
          child: Container(
              child: LottieBuilder.asset(
            "assets/Animation/Animation - 1711450914885.json",
            height: 80,
            width: 80,
            repeat: false,
          )),
        )
      ],
    );
  }
}
