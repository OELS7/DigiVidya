import 'dart:math';
import 'package:digividya/screens/Free_Time.dart';
import 'package:digividya/screens/Register.dart';
import 'package:flutter/material.dart';

class loginType extends StatefulWidget {
  const loginType({super.key});

  @override
  State<loginType> createState() => _loginTypeState();
}

class _loginTypeState extends State<loginType> {
  String device_id = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    device_id = generateDevicId();
  }

  //Function to generate random device ID
  String generateDevicId() {
    String stringPattern =
        "+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789!@#%^&*()";
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      50,
      (_) => stringPattern.codeUnitAt(random.nextInt(stringPattern.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          children: [
            // Application Logo
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 1,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/app_log/DigiVidyaLogo.webp"))),
            ),
            //
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Register(),
                        ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.59,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(33, 35, 163, 1),
                                  Color.fromRGBO(31, 35, 255, 1),
                                  Color.fromRGBO(42, 45, 255, 1),
                                  Colors.blue.shade700
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft)),
                        child: Center(
                            child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Fontmain"),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => freetime(),
                            settings: RouteSettings(arguments: {
                              "userName": "Guest",
                              "mobileNo": "1111111111",
                              "city": "Thane",
                              "device_id": device_id,
                              "language": "marathi"
                            })));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.59,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(33, 35, 163, 1),
                                  Color.fromRGBO(31, 35, 255, 1),
                                  Color.fromRGBO(42, 45, 255, 1),
                                  Colors.blue.shade700
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft)),
                        child: Center(
                            child: Text(
                          "Guest Mode",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Fontmain"),
                        )),
                      ),
                    ),
                  ]),
            ),
            Container()
          ],
        ),
      )),
    );
  }
}
