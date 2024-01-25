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
          child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/Registration & Pay Now UI_ 23 Jan Updated-04-04.png'),
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.65,
              left: MediaQuery.of(context).size.width * 0.14,
              right: MediaQuery.of(context).size.width * 0.14,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 1,
                  
                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          color: Colors.white,),
                      child: Center(
                          child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Fontmain"),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => freetime(),
                              settings: RouteSettings(arguments: {
                                "userName": "Guest",
                                "mobileNo": "1111111111",
                                "city": "Thane",
                                "device_id": device_id,
                                "language": 'Marathi'
                              })));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.59,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Center(
                          child: Text(
                        "Guest Mode",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Fontmain"),
                      )),
                    ),
                  ),
                                      ],
                                    ),
                ),
              )),
             // Positioned(child: Container( decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/app_log/DigiVidyaLogo.webp"))),)),
        ],
      )),
    );
  }
}
