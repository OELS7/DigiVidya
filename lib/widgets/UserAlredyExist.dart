import 'package:digividya/screens/Register.dart';
import 'package:flutter/material.dart';

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
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.36,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Center(
                child: Text(
              "Alredy Registered",
              style: TextStyle(
                  fontFamily: "Fontmain",
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
            )),
          ),
          // User Alredy exist Image here
          Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.39,
              child: Container(
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Center(
                  child: Text(
                    "You are already registered. Please you use your another contact number.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade900,
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
                child: Text("Go Back"),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.red, width: 3)),
              ))
        ],
      ),
    );
  }
}
