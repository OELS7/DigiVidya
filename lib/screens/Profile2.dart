import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/AboutUsPage.dart';
import 'package:digividya/screens/PrivacyPolicy.dart';
import 'package:digividya/screens/Register.dart';
import 'package:digividya/screens/SettingPage.dart';
import 'package:digividya/widgets/CustomAlertForPermission.dart';
import 'package:digividya/widgets/DeleteAccountDialog.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile2 extends StatefulWidget {
  const Profile2({super.key});

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  final imagePicker = ImagePicker();
  String UserName = "";
  get title => null;
  get content => null;
  var userId;
  String FilePath = "";
  Connectivity _connectivity = Connectivity();
  ValueNotifier<bool> profileChange = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getUserImage();
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
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width * 0.048,
                  child: ValueListenableBuilder(
                    valueListenable: profileChange,
                    builder: (context, value, child) {
                      if (value is bool) {
                        if (value) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.125,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.all(Radius.circular(100000000000000)),

                                // color: Colors.green,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(File(FilePath),),
                                    fit: BoxFit.cover)),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.125,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/ProfileIcon.webp',
                                    ),
                                    fit: BoxFit.cover)),
                          );
                        }
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.125,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/ProfileIcon.webp',
                                  ),
                                  fit: BoxFit.cover)),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.087,
                    left: MediaQuery.of(context).size.width * 0.299,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.45,
                      //color: Colors.blue,
                      margin: EdgeInsets.only(left: 10),
                      child: Center(
                        child: Text(
                          UserName,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.158,
                    left: MediaQuery.of(context).size.width * 0.219,
                    bottom: MediaQuery.of(context).size.height * 0.09,
                    // right: MediaQuery.of(context).size.width * 0.015,
                    child: InkWell(
                        onTap: () {
                          getImage();
                          print(
                              "%%%%%%%%%%%%%%% Pressing Camera Button %%%%%%%%%%%%%%%");
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                        )))
              ],
            ),
          ), //UserProfile Area

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
          ) // Other stuf of side Drawer
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
            barrierDismissible: false,
            builder: (context) {
              var internalServerErrorContext = context;
              return internalServerError(
                  internalServerErrorContext: internalServerErrorContext,
                  ErrorTitle: "No Internet",
                  description:
                      "Maybe you don't have a internet connection. Please check and try again.",
                  retryButton: () {
                    deleteaccountdetails();
                  },
                  ButtonText: "reload");
            },
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              var internalServerErrorContext = context;
              return internalServerError(
                  internalServerErrorContext: internalServerErrorContext,
                  ErrorTitle: "Poor Connection",
                  description:
                      "Maybe you have a poor internet connection. Please try again.",
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

  getImage() async {
    print(
        "%%%%%%%%%%%%%%%% Entering in getImage Method %%%%%%%%%%%%%%%%%%%%%%");

    if (await Permission.videos.isGranted) {
      final XFile? pickedFile = await pickImage();
      final Directory getApplicationDirectory = await applicationDirectory();
      final String FileName =
          await getFileName(pickedFile!.path.split(".").last);
      final String GetFilePath = await SaveFileToApplicationDirectory(
          getApplicationDirectory, FileName, pickedFile);
      SharedPreferences profileImagePath =
          await SharedPreferences.getInstance();

      setState(() {
        if (profileImagePath.containsKey("profileImage") &&
            profileImagePath.getString("profileImage")!.isNotEmpty &&
            File(profileImagePath.getString("profileImage") ?? "")
                .existsSync()) {
          print("%%%%%%%%%%%%%%% checking all condition %%%%%%%%%%%%%%%%%%%");
          // This block chnage the profile Image of user.
          if (File(profileImagePath.getString("profileImage") ?? "")
                  .existsSync() &&
              File(GetFilePath).existsSync()) {
            print(
                "%%%%%%%%%%%%%%% deleting old File from application directory %%%%%%%%%%%%%%%%%%%%%%%% ");
            File(profileImagePath.getString("profileImage") ?? "")
                .deleteSync(recursive: true); //deleting old profile image.
            profileImagePath.setString("profileImage",
                GetFilePath); // setting new file path of profileImage
            FilePath = profileImagePath.getString("profileImage") ?? "";
            profileChange.value = true;
          }
        } else {
          FilePath = GetFilePath;
          profileImagePath.setString("profileImage", GetFilePath);
          profileChange.value = true;
        }
      });
    } else {
      // AppSettings.openAppSettings(type: AppSettingsType.settings);
      _ShowAppSettingDialog();
    }
  }

  Future<XFile?> pickImage() async {
    try {
      final pickedfile = imagePicker.pickImage(source: ImageSource.gallery);
      return pickedfile;
    } catch (e) {
      print(
          "%%%%%%%%%%%%%%%%%%%%%% Error during picking Image : ${e.toString()} %%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }
    return null;
  }

  Future<Directory> applicationDirectory() async {
    final appDirectory = await getApplicationSupportDirectory();
    return appDirectory;
  }

  Future<String> getFileName(String File_extension) async {
    final FileName =
        "profile_pic_${DateTime.now().millisecondsSinceEpoch.toString()}.$File_extension";

    return FileName;
  }

  Future<String> SaveFileToApplicationDirectory(
      Directory applicationDirectory, String fileName, XFile? xFile) async {
    // xFile!.r
    File profilePic = File("${await applicationDirectory.path}/$fileName");
    profilePic.createSync(recursive: true);
    final bytes = await xFile!.readAsBytes();
    profilePic.writeAsBytesSync(bytes, flush: true);
    return profilePic.path;
  }

  void _getUserImage() async {
    SharedPreferences profileImagePath = await SharedPreferences.getInstance();

    if (profileImagePath.containsKey("profileImage") &&
        profileImagePath.getString("profileImage")!.isNotEmpty &&
        File(profileImagePath.getString("profileImage") ?? "").existsSync()) {
      FilePath = profileImagePath.getString("profileImage") ?? "";
      profileChange.value = true;
    }
  }

  void _ShowAppSettingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        var CloseDialog = context;
        return CustomAlertForPermission(OpenApp: (){
          Navigator.pop(CloseDialog,false);
          Future.delayed(Duration(milliseconds: 10),() {
            AppSettings.openAppSettings(type: AppSettingsType.apn);
          },);
        },);
      },
    );
  }
}
