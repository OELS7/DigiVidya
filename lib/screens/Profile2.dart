import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/AboutUsPage.dart';
import 'package:digividya/screens/PrivacyPolicy.dart';
import 'package:digividya/screens/Register.dart';
import 'package:digividya/screens/SettingPage.dart';
import 'package:digividya/widgets/DeleteAccountDialog.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Profile2 extends StatefulWidget {
  const Profile2({super.key});

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  String UserName = "";

  get title => null;

  get content => null;
  var userId;
  Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 220,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  image: DecorationImage(
                      image: AssetImage('assets/images/ProfileDrawer.webp'),
                      fit: BoxFit.fill)),
              child: Row(
                children: [
                  // * set profile image using image picker *
                  Container(
                    // height: 60,
                    // width: 30,

                    margin: EdgeInsets.only(left: 20),
                    child: Stack(
                      children: [
                        ProfilePicture(
                          name: '',
                          radius: 45,
                          fontsize: 28,
                        ),
                        CircleAvatar(
                          radius: 45,
                          child: Image.asset(
                            'assets/images/ProfileIcon.webp',
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Positioned(
                        //     bottom: 1,
                        //     right: 1,
                        //     child: InkWell(
                        //         onTap: () {
                        //           getImage();
                        //         },
                        //         child: Icon(
                        //           Icons.camera_alt,
                        //           size: 30,
                        //           color: Colors.white,
                        //         ))),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          UserName,
                          textAlign: TextAlign.center, 
                          softWrap: true, 
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,                        
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(5, 40, 5, 10)),
              // Container(
              //   margin: EdgeInsets.all(12),
              //   height: MediaQuery.of(context).size.height * 0.065,
              //   width: MediaQuery.of(context).size.width * 0.69,
              //   child: OutlinedButton.icon(
              //     icon: Icon(Icons.supervised_user_circle_sharp),
              //     label: Text("Profile"),
              //     onPressed: () => print("it's pressed"),
              //     style: ElevatedButton.styleFrom(
              //       side: BorderSide(width: 1.0, color: Colors.blue),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(32.0),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.69,
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: Text("Setting"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => settingPage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.69,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.info),
                  label: Text("About App"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AboutUsPage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.69,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.policy),
                  label: Text("Privacy Policy"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PrivacyPoliicy(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.69,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text("Delete Account"),
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) {
                        return DeleteAccountDialog(
                          YesButton: () {
                            Future.delayed(
                              Duration(milliseconds: 360),
                              () {
                                deleteaccountdetails();
                              },
                            );
                            Navigator.pop(ctx);
                          },
                          NoButton: () {
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Function for delete account
  deleteaccountdetails() async {
    String dirpath = (await getApplicationSupportDirectory()).path;

    File jsonFile = File("$dirpath/appInfo.json");
    //API call for Destory user history
    // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/destroyUserInfo";
    String url = "https://digividya.in/DigiVidyaAPI/api/destroyUserInfo";

    //check json file exist or not ?
    if (jsonFile.existsSync()) {
      try {
        var jsonData = jsonDecode(jsonFile.readAsStringSync());
        userId = jsonData['User_Id'];

        var userData = {"user_id": userId.toString()};
        var response = await http.post(Uri.parse(url), body: userData);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse =
              jsonDecode(response.body.toString().replaceAll("\n", " "));
          //Check json is empty or not?
          if (jsonResponse['status']) {
            //Delete directory
            // jsonFile.deleteSync(recursive: true);
            await Directory("${dirpath}").delete(recursive: true).then((_) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Register(),
              ));
            });
          }
          print("deleted user is :$jsonResponse");
        }
      } on http.ClientException catch (e) {
        print("Error Message From Profile Deletion : ${e.message}");
        final _checkConnectivity = await _connectivity.checkConnectivity();
        if (_checkConnectivity == ConnectivityResult.none) {
          showDialog(
            context: context,
            builder: (context) {
              var internalServerErrorContext = context;
              return internalServerError(
                  internalServerErrorContext: internalServerErrorContext,
                  ErrorTitle: "Internet Error",
                  description:
                      "Error on the internet Kindly verify that you are able to access the internet.",
                  retryButton: () {
                    deleteaccountdetails();
                  },
                  ButtonText: "reload");
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              var internalServerErrorContext = context;
              return internalServerError(
                  internalServerErrorContext: internalServerErrorContext,
                  ErrorTitle: "Internal Server error",
                  description:
                      "An internal server problem has occurred. Please try submitting your application again.",
                  retryButton: () {
                    deleteaccountdetails();
                  },
                  ButtonText: "try again");
            },
          );
        }
      }
    } else {
      print(
          "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Json File Not Find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }
  }

  //Fetch username from json data file to display on profile drawer
  void _getUserName() async {
    String dir = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dir/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    setState(() {
      UserName = jsonData['UserName'].toString();
    });
  }
}
