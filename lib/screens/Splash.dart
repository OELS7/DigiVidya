import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/HomePage.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/screens/LoginType.dart';
import 'package:digividya/widgets/internalServerError.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


// ignore: must_be_immutable
class Splash extends StatefulWidget {
  Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String serverDevice_Id = "";
  String GuestName = "";
  String GuestId = "";
  var values;
  Connectivity _connectivity = Connectivity();

  get title => null;

  @override
  void initState() {
    super.initState();

    _goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Splash-Screen-2.webp'),
                  fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
        ),
      ),
    );
  }

  //Function for device id
  Future<String> getDeviceId(String userId) async {
    Map<String, dynamic> UserId = {'user_id': userId};

    //print("%%%%%%%%%%%%%%%%%%%%%%%% User Id : $userId %%%%%%%%%%%%%%%%%%%%%");

    //API call for user device id
    // var url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/singleUserDeviceID";
   var url = "https://digividya.in/DigiVidyaAPI/api/singleUserDeviceID";
    try {
      var response = await http.post(Uri.parse(url), body: UserId);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
            //print("%%%%%%%%%%%%%%%%%%%%%%%%%%% device Id From Server : ${jsonRespons['device_id'].toString()} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        return jsonRespons['device_id'].toString();
      } else {
        // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Status code : ${response.statusCode} %%%%%%%%%%%%%%%%%%%%%%");
        // print("${response.body}");
        // If not get device ID show dialog
        showDialog(
          context: context,
          builder: (context) {
            var internetErrorContext = context;
            return internalServerError(
                        internalServerErrorContext: internetErrorContext,
                        ErrorTitle: "Low Internet Connection",
                        description:
                            "Poor internet connection. Please try again.",
                        ButtonText: "ok",
                        retryButton: () {
                          Future.delayed(Duration(milliseconds: 80),(){
                            getDeviceId(userId);
                          });
                          Navigator.of(internetErrorContext).pop();
                        });
          },
        );
        return "";
      }
    } on http.ClientException catch (e) {
      print(e.toString());
      return "";
    }
  }

  // For generate device ID, create json file
  void _goToNextPage() async {
    final _checkConnectivity = await _connectivity.checkConnectivity();

    // Befor login checking internet connectivity of the device.
    if (_checkConnectivity == ConnectivityResult.none) {
      // For check internet connectivity ,
      showDialog(
        context: context,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Please check your internet Connectivity.",
          );
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          var dir = (await getApplicationSupportDirectory()).path;
          File appinfoFile = File("$dir/appInfo.json");

          if (appinfoFile.existsSync()) {
            print("App config File Exist");

            values = jsonDecode(appinfoFile.readAsStringSync());

            print(values);

            if (values['UserName'] == 'Guest') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homePage(),
                  ));
            } else {
              await getDeviceId(values['User_Id'].toString()).then((value) {
                serverDevice_Id = value;
              });

              print(values['userDevice_Id'].toString());

              if ((values['userDevice_Id'].toString() == serverDevice_Id) &&
                  (values['userDevice_Id'].toString() != "")) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homePage(),
                    ));
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var internetErrorDialog = context;
                    return internalServerError(
                        internalServerErrorContext: internetErrorDialog,
                        ErrorTitle: "Internet Error",
                        description:
                            "Looks like you might be offline. Please check your internet connection and try again.",
                        ButtonText: "ok",
                        retryButton: () {
                          Navigator.of(internetErrorDialog).pop();
                        });
                  },
                );
              }
            }
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => loginType(),
                ));
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


}
