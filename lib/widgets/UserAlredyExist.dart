import 'package:digividya/screens/Register.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class userAlreadyExist extends StatefulWidget {
  const userAlreadyExist({super.key});

  @override
  State<userAlreadyExist> createState() => _userAlreadyExistState();
}

class _userAlreadyExistState extends State<userAlreadyExist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
      child: Stack(
        children: [
          Positioned(
              top: MediaQuery.of(context).size.height * 0.140,
              left: MediaQuery.of(context).size.width * 0.3,
              right: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.4,
              // width: MediaQuery.of(context).size.width * 0.02,
              child: Center(
                child: LottieBuilder.asset(
                  "assets/Animation/already_exist_user.json",
                  repeat: false,
                  fit: BoxFit.cover,
                  height: 85,
                  width: 85,
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.41,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Center(
                child: Text(
              "Already Registered",
              style: TextStyle(
                  fontFamily: "Fontmain",
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
            )),
          ),
          // User Alredy exist Image here
          Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.03,
              //bottom: MediaQuery.of(context).size.height * 0.39,
              child: Container(
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Center(
                  child: Text(
                    "You have not deleted your previous account.Please use another contact number.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(0, 123, 224, 1),
                        decoration: TextDecoration.none),
                  ),
                ),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.55,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                },
                child: Text("Go Back",style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                       // fixedSize: Size(MediaQuery.of(context).size.width * 0.02, MediaQuery.of(context).size.height * 0.02),
                    side: BorderSide(color: Colors.red, width: 3)),
              ))
        ],
      ),
    );
  }
}
