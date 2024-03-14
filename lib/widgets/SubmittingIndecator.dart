import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubmittingIndecator extends StatefulWidget {
  const SubmittingIndecator({super.key});

  @override
  State<SubmittingIndecator> createState() => _SubmittingIndecatorState();
}

class _SubmittingIndecatorState extends State<SubmittingIndecator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.35,
          bottom: MediaQuery.of(context).size.height * 0.35,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Column(
        children: [
          LottieBuilder.asset(
            "assets/Animation/Animation - 1710389401962.json",
            height: 150,
            width: 250,
          ),
          Center(
            child: Text(
              "Submitting Request",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontFamily: "Fontmain"),
            ),
          )
        ],
      ),
    );
  }
}
