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
import 'package:digividya/widgets/InternalserverError.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile2 extends StatefulWidget {
  const Profile2({super.key});

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
// Initialize ImagePicker instance
  final imagePicker = ImagePicker();
// Initialize variables
  String UserName = "";
  get title => null;
  get content => null;
  var userId;
  String FilePath = "";
// Initialize Connectivity instance
  Connectivity _connectivity = Connectivity();
// Initialize ValueNotifier for profile change
  ValueNotifier<bool> profileChange = ValueNotifier<bool>(false);

// Override initState method
  @override
  void initState() {
    super.initState();
    // Fetch username
    _getUserName();
    // Fetch user image
    _getUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Container for user profile
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
            child: // Stack widget containing positioned elements
                Stack(
              children: [
                // Positioned container for profile image
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width * 0.048,
                  child: ValueListenableBuilder(
                    valueListenable: profileChange,
                    builder: (context, value, child) {
                      if (value is bool) {
                        // Check if user profile image is available
                        if (value) {
                          // Display user profile image
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.125,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File(FilePath)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          // Display default profile image
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.125,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/ProfileIcon.webp',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      } else {
                        // Display default profile image if value is not bool
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.125,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/ProfileIcon.webp',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                // Positioned container for user name
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.087,
                  left: MediaQuery.of(context).size.width * 0.299,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.45,
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
                  ),
                ),
                // Positioned container for camera button
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.158,
                  left: MediaQuery.of(context).size.width * 0.219,
                  bottom: MediaQuery.of(context).size.height * 0.09,
                  child: InkWell(
                    onTap: () {
                      // Function to handle camera button tap
                      getImage();
                      print(
                          "%%%%%%%%%%%%%%% Pressing Camera Button %%%%%%%%%%%%%%%");
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ), //UserProfile Area

// Column containing various settings options
Column(
  children: [
    Padding(padding: EdgeInsets.fromLTRB(5, 40, 5, 10)),
    // Container for "Settings" option
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
          // Navigate to the settings page
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
    // Container for "About App" option
    Container(
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.69,
      child: OutlinedButton.icon(
        icon: Icon(Icons.info),
        label: Text("About App"),
        onPressed: () {
          // Navigate to the About Us page
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
    // Container for "Privacy Policy" option
    Container(
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.69,
      child: OutlinedButton.icon(
        icon: Icon(Icons.policy),
        label: Text("Privacy Policy"),
        onPressed: () {
          // Navigate to the Privacy Policy page
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
    // Container for "Feedback" option
    Container(
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.69,
      child: OutlinedButton.icon(
        icon: Icon(Icons.feedback),
        label: Text("Feedback"),
        onPressed: openplaystore, // Function to open play store for feedback
        style: ElevatedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    ),
    // Container for "Delete Account" option
    Container(
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.69,
      child: OutlinedButton.icon(
        icon: Icon(Icons.delete),
        label: Text("Delete Account"),
        onPressed: () {
          // Show confirmation dialog before deleting account
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return DeleteAccountDialog(
                YesButton: () {
                  // Delay before deleting account
                  Future.delayed(
                    Duration(milliseconds: 360),
                    () {
                      deleteaccountdetails(); // Function to delete account
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
),
// Other stuf of side Drawer
        ],
      ),
    );
  }

// Function for deleting the user account details
deleteaccountdetails() async {
  // Get the directory path for storing application data
  String dirpath = (await getApplicationSupportDirectory()).path;

  // Define the path for the JSON file containing app information
  File jsonFile = File("$dirpath/appInfo.json");

  // Define the API endpoint for destroying user information
  String url = "https://digividya.in/DigiVidyaAPI/api/destroyUserInfo";

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    try {
      // Read JSON data from the file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      userId = jsonData['User_Id'];

      // Prepare user data for API call
      var userData = {"user_id": userId.toString()};
      
      // Send HTTP POST request to destroy user information
      var response = await http.post(Uri.parse(url), body: userData);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        // Check if the deletion was successful
        if (jsonResponse['status']) {
          // Delete the directory containing user data
          await Directory("${dirpath}").delete(recursive: true).then((_) {
            // Navigate to the registration page after deletion
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Register(),
            ));
          });
        }
        print("deleted user is :$jsonResponse");
      }
    } on http.ClientException catch (e) {
      // Handle HTTP client exceptions
      print("Error Message From Profile Deletion : ${e.message}");
      
      // Check connectivity status
      final _checkConnectivity = await _connectivity.checkConnectivity();
      
      // Show appropriate error dialog based on connectivity status
      if (_checkConnectivity == ConnectivityResult.none) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var InternalserverErrorContext = context;
            return InternalserverError(
                InternalserverErrorContext: InternalserverErrorContext,
                ErrorTitle: "No Internet",
                 Description:
                    "Maybe you don't have an internet connection. Please check and try again.",
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
            var InternalserverErrorContext = context;
            return InternalserverError(
                InternalserverErrorContext: InternalserverErrorContext,
                ErrorTitle: "Poor Connection",
                 Description:
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
    // Print message if JSON file is not found
    print(
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Json File Not Find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  }
}


// Function to fetch the username from the JSON data file and update the state to display on the profile drawer
void _getUserName() async {
  // Get the directory path for storing application data
  String dir = (await getApplicationSupportDirectory()).path;

  // Define the path for the JSON file containing app information
  File jsonFile = File("$dir/appInfo.json");

  // Read JSON data from the file
  var jsonData = jsonDecode(jsonFile.readAsStringSync());

  // Update the state with the fetched username
  setState(() {
    UserName = jsonData['UserName'].toString();
  });
}


// Function to get the user image
getImage() async {
  // Print statement to indicate entering the getImage method
  print("%%%%%%%%%%%%%%%% Entering in getImage Method %%%%%%%%%%%%%%%%%%%%%%");

  // Check if permission to access videos is granted
  if (await Permission.videos.isGranted) {
    // Pick an image using the image picker
    final XFile? pickedFile = await pickImage();

    // Get the application directory
    final Directory getApplicationDirectory = await applicationDirectory();

    // Get the file name and extension
    final String FileName = await getFileName(pickedFile!.path.split(".").last);

    // Get the file path for saving the image
    final String GetFilePath = await SaveFileToApplicationDirectory(getApplicationDirectory, FileName, pickedFile);

    // Get SharedPreferences for storing profile image path
    SharedPreferences profileImagePath = await SharedPreferences.getInstance();

    setState(() {
      // Check if profile image path is already stored and not empty
      if (profileImagePath.containsKey("profileImage") &&
          profileImagePath.getString("profileImage")!.isNotEmpty &&
          File(profileImagePath.getString("profileImage") ?? "").existsSync()) {
        // Print statement to indicate checking all conditions
        print("%%%%%%%%%%%%%%% checking all condition %%%%%%%%%%%%%%%%%%%");

        // Check if both old and new files exist
        if (File(profileImagePath.getString("profileImage") ?? "").existsSync() &&
            File(GetFilePath).existsSync()) {
          // Print statement to indicate deleting old file from the application directory
          print("%%%%%%%%%%%%%%% deleting old File from application directory %%%%%%%%%%%%%%%%%%%%%%%% ");

          // Delete the old profile image
          File(profileImagePath.getString("profileImage") ?? "").deleteSync(recursive: true);

          // Set the new file path of the profile image
          profileImagePath.setString("profileImage", GetFilePath);
          
          // Set the FilePath variable to the new profile image path
          FilePath = profileImagePath.getString("profileImage") ?? "";

          // Trigger profileChange value notifier to update the profile image
          profileChange.value = true;
        }
      } else {
        // Set the FilePath variable to the new profile image path
        FilePath = GetFilePath;

        // Set the profile image path in SharedPreferences
        profileImagePath.setString("profileImage", GetFilePath);

        // Trigger profileChange value notifier to update the profile image
        profileChange.value = true;
      }
    });
  } else {
    // If permission to access videos is not granted, show app settings dialog
    _ShowAppSettingDialog();
  }
}


// Function to pick an image from the gallery
Future<XFile?> pickImage() async {
  try {
    // Pick an image from the gallery using the imagePicker
    final pickedfile = imagePicker.pickImage(source: ImageSource.gallery);
    return pickedfile;
  } catch (e) {
    // Print error message if there's an error during picking the image
    print("%%%%%%%%%%%%%%%%%%%%%% Error during picking Image : ${e.toString()} %%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  }
  return null;
}

// Function to get the application directory
Future<Directory> applicationDirectory() async {
  // Get the application support directory
  final appDirectory = await getApplicationSupportDirectory();
  return appDirectory;
}

// Function to generate a file name with the provided file extension
Future<String> getFileName(String File_extension) async {
  // Generate a file name with the current timestamp and provided file extension
  final FileName = "profile_pic_${DateTime.now().millisecondsSinceEpoch.toString()}.$File_extension";
  return FileName;
}

// Function to save the file to the application directory
Future<String> SaveFileToApplicationDirectory(Directory applicationDirectory, String fileName, XFile? xFile) async {
  // Create a file object for the profile picture
  File profilePic = File("${await applicationDirectory.path}/$fileName");
  profilePic.createSync(recursive: true);

  // Read the bytes of the picked image file
  final bytes = await xFile!.readAsBytes();

  // Write the bytes to the profile picture file
  profilePic.writeAsBytesSync(bytes, flush: true);

  // Return the path of the saved profile picture file
  return profilePic.path;
}

// Function to get the user image from SharedPreferences
void _getUserImage() async {
  SharedPreferences profileImagePath = await SharedPreferences.getInstance();

  // Check if the profile image path is stored in SharedPreferences and if the file exists
  if (profileImagePath.containsKey("profileImage") &&
      profileImagePath.getString("profileImage")!.isNotEmpty &&
      File(profileImagePath.getString("profileImage") ?? "").existsSync()) {
    // Set the FilePath variable to the profile image path
    FilePath = profileImagePath.getString("profileImage") ?? "";
    
    // Trigger profileChange value notifier to update the profile image
    profileChange.value = true;
  }
}

// Function to show the app settings dialog
void _ShowAppSettingDialog() {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var CloseDialog = context;
      return CustomAlertForPermission(
        OpenApp: () {
          // Close the dialog and open app settings
          Navigator.pop(CloseDialog, false);
          Future.delayed(
            Duration(milliseconds: 10),
            () {
              AppSettings.openAppSettings(type: AppSettingsType.apn);
            },
          );
        },
      );
    },
  );
}


// Function to open the Play Store
Future<void> openplaystore() async {
  // Check if the platform is Android
  if (Platform.isAndroid) {
    // Define the Play Store URL for the app
    const url = "https://play.google.com/store/apps/details?id=com.digividya_2023";
    
    // Check if the URL can be launched
    if (await canLaunchUrl(Uri.parse(url))) {
      // Launch the URL
      await launchUrl(Uri.parse(url));
    } else {
      // Throw an error if the URL cannot be launched
      throw 'could not launch playstore link';
    }
  } else {
    // Throw an error if the platform is not supported
    throw 'Unsupported Platform';
  }
}

}
