import 'package:digividya/screens/AppIntroVideoPlayer.dart';
import 'package:flutter/material.dart';

class languagePage extends StatefulWidget {
  const languagePage({super.key});

  @override
  State<languagePage> createState() => _languagePageState();
}

class _languagePageState extends State<languagePage> {
  String userName = "";
  String mobilenumber = "";
  String city = "";
  String deviceId = "";
  @override
  Widget build(BuildContext context) {
    var argument = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;

    userName = argument['Username'];
    mobilenumber = argument['mobileNo'];
    city = argument['city'];
    deviceId = argument['deviceId'];

    print("$deviceId");

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Language.webp'),
                            fit: BoxFit.fill)),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 70, 15, 15),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Choose Your",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Fontmain',
                                  color: Colors.white),
                            ),
                            Text(
                              " Language",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Fontmain',
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.6,
                //color: Colors.blue,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height / 9.3,
                      left: MediaQuery.of(context).size.width / 10.2,
                      right: MediaQuery.of(context).size.width / 10.2,
                      child: GestureDetector(
                          //Navigate to download app intro marathi video
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: ((context) => vediopage(
                                    language: 'Marathi',
                                    userName: userName,
                                    mobilenumber: mobilenumber,
                                    city: city,
                                    device_id: deviceId,
                                  )),
                            ));
                          },
                          child: Container(
                            height: 75,
                            width: 220,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Button-23-min.webp'),
                                    fit: BoxFit.fill)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'मराठी',
                                style: TextStyle(
                                    fontFamily: 'Fontmain',
                                    color: Colors.white,
                                    fontSize: 26),
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 3.4,
                      left: MediaQuery.of(context).size.width / 10.2,
                      right: MediaQuery.of(context).size.width / 10.2,
                      child: GestureDetector(
                          //Navigate to download app intro of hindi
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: ((context) => vediopage(
                                    language: 'Hindi',
                                    userName: userName,
                                    mobilenumber: mobilenumber,
                                    device_id: deviceId,
                                    city: city,
                                  )),
                            ));

                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: false,
                            //   builder: (context) {
                            //     var commingsoonContext = context;
                            //     return commingSoonAlertbox(
                            //         comingSoonDialogContext:
                            //             commingsoonContext);
                            //   },
                            // );
                          },
                          child: Container(
                            height: 75,
                            width: 220,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Button-23-min.webp'),
                                    fit: BoxFit.fill)),
                            child: Center(
                                child: Text(
                              'हिंदी',
                              style: TextStyle(
                                  fontFamily: 'Fontmain',
                                  color: Colors.white,
                                  fontSize: 26),
                            )),
                          )),
                    ),
                    // GestureDetector(
                    //     //Navigate to download english app intro
                    //     onTap: () {
                    //       Navigator.of(context)
                    //           .pushReplacement(MaterialPageRoute(
                    //               builder: ((context) => downloadScreen()),
                    //               settings: RouteSettings(arguments: {
                    //                 'language': 'english',
                    //                 'userName': userName,
                    //                 'mobilenumber': mobilenumber,
                    //                 'city': city,
                    //                 'deviceid': deviceId
                    //               })));
                    //     },
                    //     child: Container(
                    //       height: 75,
                    //       width: 220,
                    //       decoration: BoxDecoration(
                    //           image: DecorationImage(
                    //               image: AssetImage(
                    //                   'assets/images/Button-23-min.webp'),
                    //               fit: BoxFit.fill)),
                    //       child: Center(
                    //           child: Text(
                    //         'English',
                    //         style: TextStyle(
                    //             fontFamily: 'Fontmain',
                    //             color: Colors.white,
                    //             fontSize: 26),
                    //       )),
                    //     )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
