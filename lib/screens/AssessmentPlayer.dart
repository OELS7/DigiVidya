import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digividya/widgets/LikeDialog.dart';
import 'package:digividya/widgets/exitAssessment.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/assessmentDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

class assessmentPlayer extends StatefulWidget {
  const assessmentPlayer({super.key});

  @override
  State<assessmentPlayer> createState() => _assessmentPlayerState();
}

class _assessmentPlayerState extends State<assessmentPlayer> {
// Declare integer variables to track the section, topic, topic count, sub-topic, sub-topic count, and item pointer
  int section = 0, // Initialize section to 0
      topic = 0, // Initialize topic to 0
      topicCount = 0, // Initialize topicCount to 0
      subTopic = 0, // Initialize subTopic to 0
      subTopicCount = 0, // Initialize subTopicCount to 0
      itemPointer = 0; // Initialize itemPointer to 0

// Declare a string variable to hold the assessment file path
  String assessFilePath = "";

// Declare a list of dynamic type to hold content URLs
  List<dynamic> contentUrls = [];

// Declare a list of strings to hold file names
  List<String> FileName = [];

// Declare a list of strings to hold device file names
  List<String> deviceFileName = [];

// Declare a list of strings to hold device file paths
  List<String> deviceFilePath = [];

// Declare a ValueNotifier to track the state of the heart button press
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);

  late String directory;

// Declare a variable to hold the page context
  var pageContext;

  @override
  void initState() {
    getDirectory();

    // Call the initState method of the superclass to ensure proper initialization
    super.initState();
    // Call the _getDeviceFileName method to retrieve the device file names
    _getDiviceFileName();
  }

// Override the build method to describe how to display the widget
  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed through the route
    var argument = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;

    // Store the context in the pageContext variable for later use
    pageContext = context;

    // Extract various parameters from the arguments
    assessFilePath = argument['htmlFilePath'];
    section = argument['section'];
    topic = argument['topic'];
    topicCount = argument['topicCount'];
    subTopic = argument['subTopic'];
    subTopicCount = argument['subTopicCount'];
    itemPointer = argument['itemPointer'];
    contentUrls = argument['contentUrls'];
    FileName = argument['FileName'];

    // Start downloading the next file if there are more files to download
    (contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : _startDownload(fileUrl: contentUrls[itemPointer + 1]);

    // Return a Scaffold widget which provides the structure for the page
    return Scaffold(
      // App bar with a custom back button
      appBar: AppBar(
        leading: Row(
          children: [
            // Back button to handle back navigation
            BackButton(
              onPressed: () {
                _onBackButtonPressed();
              },
            ),
            // Text label for the back button
            Text("Back")
          ],
        ),
        // Set the width of the leading widget to the full width of the screen
        leadingWidth: MediaQuery.of(context).size.width * 1,
      ),
      // SafeArea widget to avoid operating system interfaces
      body: SafeArea(
        // InAppWebView to display web content
        child: InAppWebView(
          // Set options when the web view is created
          onWebViewCreated: (controller) {
            controller.setOptions(
                options: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                preferredContentMode: UserPreferredContentMode.MOBILE,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                useShouldOverrideUrlLoading: true,
                javaScriptEnabled: true,
              ),
            ));

            // Load the URL specified in assessFilePath
            controller.loadUrl(
                urlRequest: URLRequest(url: Uri.parse(assessFilePath)));
          },
          // Handle console messages for full screen exit
          onConsoleMessage: (controller, consoleMessage) {
            if (consoleMessage.message == "exit") {
              // Exit full screen mode
              controller.evaluateJavascript(source: """
                                      document.exitFullscreen();
                                      """);

              // Show a dialog box with options to reload or proceed to the next video
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var assessmentDialogBox = context;
                    return assessmentDialog(playAgainButton: () {
                      controller.reload();
                      Navigator.pop(assessmentDialogBox);
                    }, proceedToNextVideo: () {
                      Future.delayed(
                        Duration(milliseconds: 900),
                        () {
                          _goToNextVideo(assessmentDialogBox);
                        },
                      );
                      Navigator.pop(assessmentDialogBox);
                    });
                  });
            }
          },
        ),
      ),
    );
  }

  void _goToNextVideo(BuildContext assessmentDialogBox) async {

    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    String _directory ="";

    (deviceInfo.version.sdkInt < 33)
        ? (Directory((await getDownloadsDirectory())!.path).existsSync())
            ? _directory = (await getDownloadsDirectory())!.path
            : Directory((await getDownloadsDirectory())!.path)
                .create(recursive: true)
                .then((value) {
                _directory= value.path.toString();
              })
        : _directory = (await getApplicationSupportDirectory()).path;

    // Check if the current item is not the last one in the list
    if (itemPointer != contentUrls.length - 1) {
      // Get the application support directory path
     // String DirPath = (await getApplicationSupportDirectory()).path;
      // Define the path for the assessment directory
      Directory AssessmentDirectory = Directory(
          "$_directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer].split(".zip").first}/");

      // Check if the assessment directory exists
      if (AssessmentDirectory.existsSync()) {
        // Delete the assessment directory recursively
        await AssessmentDirectory.delete(recursive: true).then((_) {
          // Get the file extension of the next file
          String fileExtension =
              FileName[itemPointer + 1].toString().split(".").last.toString();

          // Switch based on the file extension
          switch (fileExtension) {
            case "mp4":
              // Play the specific video file
              _playSpecificFile(
                  filePath:
                      "$_directory/DigiVidya/Section_${section}/VideoFiles/Topic_${topic}/subTopic_${subTopic}/Video/${FileName[itemPointer + 1]}");
              break;
            case "zip":
              // Play the specific assessment file
              _playSpecificFile(
                  filePath:
                      "$_directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer + 1]}");
              break;
            default:
          }
        });
      }
    } else {
      // If the current item is the last one, show a dialog to the user
      showDialog(
        context: context,
        builder: (context) {
          var LikeDialogBox = context;
          return LikeDialog(
            yesButton: () {
              // If the user presses yes, update the heartButtonPressed value and like the sub-topic
              heartButtonPressed.value = true;
              _likeSubTopic();

              // Close the dialog after a short delay
              Future.delayed(
                Duration(milliseconds: 70),
                () {
                  Navigator.of(LikeDialogBox).pop();
                },
              );
            },
            noButton: () async {
              // If the user presses no, get the user and sub-topic IDs from the appInfo.json file
              //String dir = (await getApplicationSupportDirectory()).path;
              File jsonFile = File("$directory/appInfo.json");
              var jsonData = jsonDecode(jsonFile.readAsStringSync());
              String user_Id = jsonData['User_Id'].toString();
              String subTopic_Id = jsonData['subTopic_Id'].toString();

              // Call the demo progress method with the retrieved IDs
              _demoprogrees(
                  user_Id: user_Id,
                  topic_Id: topic.toString(),
                  subTopic_Id: subTopic_Id);

              // Navigate to the bannerAd page after a short delay
              Future.delayed(Duration(milliseconds: 300), () {
                Navigator.pushReplacementNamed(pageContext, "/bannerAd",
                    arguments: {
                      "section": section,
                      "topic": topic,
                      "topicCount": topicCount,
                      "subTopicCount": subTopicCount
                    });
              });
              // Close the dialog
              Navigator.of(LikeDialogBox).pop();
            },
            heartButtonPressed: heartButtonPressed,
          );
        },
      );
    }
  }

  void _startDownload({required String fileUrl}) async {
    // Check if the file URL ends with ".mp4" indicating it's a video file
    if (fileUrl.split("/").last.split(".").last == "mp4") {

                  String _directory = "";

    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    (deviceInfo.version.sdkInt < 33)
        ? (Directory((await getDownloadsDirectory())!.path).existsSync())
            ? _directory = (await getDownloadsDirectory())!.path
            : Directory((await getDownloadsDirectory())!.path)
                .create(recursive: true)
                .then((value) {
                _directory= value.path.toString();
              })
        : _directory = (await getApplicationSupportDirectory()).path;

      // Define the URL for video download
      String url = "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl";
      // Get the application support directory path
      //String dir = (await getApplicationSupportDirectory()).path;
      // Define the path for the video file
      File videoFile = File(
          "$_directory/DigiVidya/Section_${section}/VideoFiles/Topic_${topic}/subTopic_${subTopic}/Video/${FileName[itemPointer + 1]}");

      // Check if the video file doesn't exist
      if (!videoFile.existsSync()) {
        // Initialize a receive port for the main thread
        ReceivePort mainThreadReceiver = ReceivePort();
        // Initialize a separate isolate for downloading
        await Isolate.spawn(_downloadContent, {
          "url": url,
          "location": videoFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listen for messages from the separate isolate
        mainThreadReceiver.listen((message) {
          if (message is String) {
            if (message.isNotEmpty && (message.toString() != "download fail")) {
              print("Video File Downloading");
              print("$message % Downloaded");
            } else {
              // Show an internet error dialog if download fails
              showDialog(
                context: context,
                builder: (context) {
                  var dialogContext = context;
                  return InternetErrorDialog(
                    internetErrorDialogContext: dialogContext,
                    message:
                        "Low internet connection . Please check your internet.",
                  );
                },
              );
              print("Download Fail");
            }
          }
        });
      }
    } else {
      // Define the URL for assignment download
      String url = "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl";
      // Get the application support directory path
      //String dir = (await getApplicationSupportDirectory()).path;
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
      String _directory = "";

          (deviceInfo.version.sdkInt < 33)
        ? (Directory((await getDownloadsDirectory())!.path).existsSync())
            ? _directory = (await getDownloadsDirectory())!.path
            : Directory((await getDownloadsDirectory())!.path)
                .create(recursive: true)
                .then((value) {
                _directory= value.path.toString();
              })
        : _directory = (await getApplicationSupportDirectory()).path;

      // Define the path for the assessment zip file
      File AssessmentZipFile = File(
          "$_directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer + 1]}");

      // Check if the assessment zip file doesn't exist
      if (!AssessmentZipFile.existsSync()) {
        // Check if there's a corresponding file in the device's file path list and delete it
        if ((itemPointer + 1) < deviceFilePath.length) {
          if (await File(deviceFilePath[itemPointer + 1].toString())
              .existsSync()) {
            File(deviceFilePath[itemPointer + 1].toString())
                .deleteSync(recursive: true);
          }
        }

        // Initialize a receive port for the main thread
        ReceivePort mainThreadReceiver = ReceivePort();
        // Initialize a separate isolate for downloading
        await Isolate.spawn(_downloadContent, {
          "url": url,
          "location": AssessmentZipFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listen for messages from the separate isolate
        mainThreadReceiver.listen((message) {
          if (message is String) {
            if (message.isNotEmpty && (message.toString() != "download fail")) {
              print("Assessment Zip File Downloading");
              print("$message % Downloaded");
            } else {
              // Show an internet error dialog if download fails
              showDialog(
                context: context,
                builder: (context) {
                  var dialogContext = context;
                  return InternetErrorDialog(
                    internetErrorDialogContext: dialogContext,
                    message:
                        "Low internet connection . Please check your internet.",
                  );
                },
              );
              print("Download Fail");
            }
          }
        });
      } else {
        // Check if the file name doesn't match with the device's file name
        if (FileName[itemPointer] != deviceFileName[itemPointer]) {
          // Perform necessary operations if needed
          // (Code commented out)
        }
      }
    }
  }

  ///This function determines the type of file based on its extension,
  ///handles MP4 videos, and extracts or navigates to the appropriate assessment page for ZIP files.

  void _playSpecificFile({required String filePath}) async {
    // Extract file extension from the file path
    String fileExtension = filePath.split("/").last.split('.').last.toString();

    // Check the file extension and handle accordingly
    switch (fileExtension) {
      // If the file is an mp4 video
      case "mp4":
        // Navigate to the video page with appropriate arguments
        Navigator.pushReplacementNamed(context, '/vidoePage', arguments: {
          "filePath": filePath,
          "minutes": 0,
          "seconds": 0,
          "section": section,
          "topic": topic,
          "topicCount": topicCount,
          "subTopic": subTopic,
          "subTopicCount": subTopicCount,
          "contentUrls": contentUrls,
          "itemPointer": itemPointer + 1,
          "FileName": FileName
        });
        break;
      // If the file is a zip file
      case "zip":
        // Define the directory for assessment
        Directory AssessmentDirectory =
            Directory("${filePath.split("/").last.split(".zip").first}/");
        // Check if the assessment directory exists
        if (AssessmentDirectory.existsSync()) {
          // Check if the assessment HTML file exists
          File assessmentHtmlFile = File(
              "${filePath.split("/").last.split(".zip").first}/story_html5.html");
          if (assessmentHtmlFile.existsSync()) {
            // Navigate to the assessment page with HTML file path
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath": assessmentHtmlFile.path,
                  "section": section,
                  "topic": topic,
                  "topicCount": topicCount,
                  "subTopic": subTopic,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": itemPointer + 1,
                  "FileName": FileName
                });
          } else {
            // Navigate to the assessment page with HTML file path
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath":
                      "${filePath.split("/").last.split(".zip").first}/story.html",
                  "section": section,
                  "topic": topic,
                  "topicCount": topicCount,
                  "subTopic": subTopic,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": itemPointer + 1,
                  "FileName": FileName
                });
          }
        } else {
          // Extract the zip file to the assessment directory
         // String dir = (await getApplicationSupportDirectory()).path;
          Directory AssessmentDirectory = Directory(
              "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/");
          ZipFile.extractToDirectory(
                  zipFile: File(filePath), destinationDir: AssessmentDirectory)
              .then((_) {
            // Check if the assessment HTML file exists
            File assessmentHtmlFile = File(
                "${filePath.split("/").last.split(".zip").first}/story_html5.html");

            if (assessmentHtmlFile.existsSync()) {
              // Navigate to the assessment page with HTML file path
              Navigator.pushReplacementNamed(context, '/assessmentPage',
                  arguments: {
                    "htmlFilePath": assessmentHtmlFile.path,
                    "section": section,
                    "topic": topic,
                    "topicCount": topicCount,
                    "subTopic": subTopic,
                    "subTopicCount": subTopicCount,
                    "contentUrls": contentUrls,
                    "itemPointer": itemPointer + 1,
                    "FileName": FileName
                  });
            } else {
              // Navigate to the assessment page with HTML file path
              Navigator.pushReplacementNamed(context, '/assessmentPage',
                  arguments: {
                    "htmlFilePath":
                        "${filePath.split("/").last.split(".zip").first}/story.html",
                    "section": section,
                    "topic": topic,
                    "topicCount": topicCount,
                    "subTopic": subTopic,
                    "subTopicCount": subTopicCount,
                    "contentUrls": contentUrls,
                    "itemPointer": itemPointer + 1,
                    "FileName": FileName
                  });
            }
          });
        }
        break;
      default:
    }
  }

  /// This function performs various actions related to liking a subtopic,
  /// including making an API call, updating JSON data, and navigating to
  /// another page based on the response.
  /// It also handles errors related to HTTP requests and exceptions.
  void _likeSubTopic() async {
    // Get the directory path
    //String dir = (await getApplicationSupportDirectory()).path;
    // Access the JSON file
    File jsonFile = File("$directory/appInfo.json");
    // Decode the JSON data
    var jsonData = jsonDecode(jsonFile.readAsStringSync());

    try {
      // Extract user ID and subtopic ID from JSON data
      String user_Id = jsonData['User_Id'].toString();
      String subTopic_Id = jsonData['subTopic_Id'].toString();

      // Prepare data to send for API call
      var sendUserData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
      // Define API URL for liking a subtopic
      String api_Url =
          "https://digividya.in/DigiVidyaAPI/api/storeLikesForSubtopic";

      // Make HTTP POST request to like the subtopic
      var response = await http.post(Uri.parse(api_Url), body: sendUserData);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the response data
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        // Check if liking the subtopic was successful
        if (jsonResponse['status']) {
          // Update subtopic ID in JSON data
          jsonData['subTopic_Id'] = "";
          // Write updated JSON data to file
          jsonFile.writeAsStringSync(jsonEncode(jsonData));
          // Perform additional actions after liking the subtopic
          _demoprogrees(
              user_Id: user_Id,
              topic_Id: topic.toString(),
              subTopic_Id: subTopic_Id);
          // Navigate to another page
          Future.delayed(
            Duration(milliseconds: 600),
            () {
              Navigator.pushReplacementNamed(context, "/bannerAd", arguments: {
                "section": section,
                "topic": topic,
                "topicCount": topicCount,
                "subTopicCount": subTopicCount
              });
            },
          );
        } else {
          // Navigate to another page
          Future.delayed(
            Duration(milliseconds: 600),
            () {
              Navigator.pushReplacementNamed(context, "/bannerAd", arguments: {
                "section": section,
                "topic": topic,
                "topicCount": topicCount,
                "subTopicCount": subTopicCount
              });
            },
          );
        }
      } else {
        // Show error dialog for low internet connection
        showDialog(
          context: context,
          builder: (context) {
            var internetErrorDialogContext = context;
            return InternetErrorDialog(
              internetErrorDialogContext: internetErrorDialogContext,
              message: "Low internet connection . Please check your internet.",
            );
          },
        );
      }
    } on http.ClientException catch (e) {
      // Show error dialog for low internet connection
      showDialog(
        context: context,
        builder: (context) {
          var internetErrorDialogContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorDialogContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
      // Print the exception details
      print("This Occurred when Client Exception Happened.. :${e.toString()}");
    } on Exception catch (e) {
      // Show error dialog for low internet connection
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var internetErrorDialogContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorDialogContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
      // Print the exception details
      print("This Occurred when any Exception happened : ${e.toString()}");
    }
  }

  ///Function for userprogress (subtopic complete)
  ///
  /// This method store the progress of user on the server.
  // void _setSubTopicCompleted(
  //     {required String user_Id, required String subTopic_Id}) async {
  //   //API call for user progress
  //   // String Api_Url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateUserProgress";
  //   String Api_Url = "https://digividya.in/DigiVidyaAPI/api/updateUserProgress";
  //   String dir = (await getApplicationSupportDirectory()).path;
  //   File jsonFile = File("$dir/appInfo.json");
  //   var jsonData = jsonDecode(jsonFile.readAsStringSync());
  //   if (!jsonData.containsKey("completedSubTopic")) {
  //     var userData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
  //     var response = await http.post(Uri.parse(Api_Url), body: userData);
  //     if (response.statusCode == 200) {
  //       print("${response.body.replaceAll("\n", " ")}");
  //     }
  //   } else {
  //     List completedSubTopicList = jsonData['completedSubTopic'];

  //     if (!completedSubTopicList.contains(subTopic_Id)) {
  //       completedSubTopicList.add(subTopic_Id);
  //       jsonData['completedSubTopic'] = completedSubTopicList;
  //     }

  //     var userData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
  //     var response = await http.post(Uri.parse(Api_Url), body: userData);
  //     if (response.statusCode == 200) {}
  //   }
  // }

  /// This function is responsible for making an HTTP POST request
  ///  to insert user progress into the database. It sends user ID,
  /// topic ID, and subtopic ID as parameters to the API endpoint.
  /// If the request is successful (status code 200), it prints the response body.
  void _demoprogrees(
      {required String user_Id,
      // required String section_Id,
      required String topic_Id,
      required String subTopic_Id}) async {
    // Define API URL for inserting user progress
    String Api_url = "https://digividya.in/DigiVidyaAPI/api/insertUserProgress";

    // Prepare data to send for API call
    var userData = {
      "user_id": user_Id,
      // "section_id": section_Id,
      "topic_id": topic_Id,
      "subtopic_id": subTopic_Id
    };

    // Make HTTP POST request to insert user progress
    var response = await http.post(Uri.parse(Api_url), body: userData);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Print the response body
      print("${response.body.replaceAll("\n", " ")}");
    }
  }

  /// This function displays a dialog when the back button is pressed to
  /// confirm if the user wants to exit the assessment. If the user confirms (presses yes),
  /// it navigates to the subTopicPage. If the user cancels (presses no), it returns false.
  Future<bool> _onBackButtonPressed() async {
    // Show a dialog to confirm if the user wants to exit the assessment
    return (await showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) {
            var dialogBoc = context;
            return exitAssessment(
              yesButtonFuntion: () {
                // If user confirms, navigate to the subTopicPage
                Future.delayed(
                  Duration(milliseconds: 300),
                  () {
                    Navigator.pushReplacementNamed(pageContext, "/subTopicPage",
                        arguments: {
                          "section": section,
                          "topic": topic,
                          "topicCount": topicCount,
                          "subTopicCount": subTopicCount,
                        });
                    print("Navigate to subTopic page");
                  },
                );
                Navigator.pop(dialogBoc);
              },
              noButtonFunction: () {
                // If user cancels, return false
                Navigator.of(dialogBoc).pop(false);
              },
            );
          },
        )) ??
        false;
  }

  /// This dispose method is called when the State object is
  /// removed from the tree permanently. It calls the superclass's dispose method
  ///  and clears the contentUrls and FileName lists to free up memory. However, it
  /// seems that the clearing of lists is commented out, so they are not actually cleared.
  @override
  void dispose() {
    // Call the superclass's dispose method
    super.dispose();
    // Clear the lists to free up memory
    // contentUrls.clear();
    // FileName.clear();
  }

  ///This function asynchronously retrieves the path of the
  ///application support directory. Then, it checks if the assessment directory
  ///exists within the specified section, topic, and subtopic. If it exists, it lists all
  ///files in that directory. For each file found, it extracts the file name and path and adds them
  ///to the deviceFileName and deviceFilePath lists, respectively.

// Asynchronously get the application support directory path
  _getDiviceFileName() async {
    String directory = (await getApplicationSupportDirectory()).path;

    // Check if the assessment directory exists
    if (Directory(
            "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/")
        .existsSync()) {
      // List all files in the assessment directory
      Directory(
              "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topic}/subTopic_${subTopic}/Assessment/")
          .listSync()
          .forEach((element) {
        // If the element is a file, extract its name and path
        if (element is File) {
          deviceFileName
              .add(path.basename(element.path).toString().split(".").first);
          deviceFilePath.add(element.path.toString());
        }
      });
    }
  }

  void getDirectory() async {
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    if (deviceInfo.version.sdkInt < 33) {
      if (Directory((await getDownloadsDirectory())!.path).existsSync()) {
       
          directory = (await getDownloadsDirectory())!.path;
   
      } else {
        Directory((await getDownloadsDirectory())!.path)
            .create(recursive: true)
            .then((value) {
          setState(() {
            directory = value.path.toString();
          });
        });
      }
    } else {
      setState(() async {
        directory = (await getApplicationSupportDirectory()).path;
      });
    }
  }
}

///This function downloads content from a specified URL to
/// a specified location. It listens for the download progress and sends
/// updates through the provided sendPort. In case of any errors or exceptions, it sends a message
/// indicating download failure through the sendPort.

// Define the function to download content with a specified message containing URL, location, and sendPort
void _downloadContent(Map<String, dynamic> message) {
  // Extract URL and download location from the message
  String fileUrl = message["url"].toString();
  String downloadLocation = message['location'].toString();

  // Extract the sendPort from the message
  final sendPort = message['sendPort'] as SendPort;

  // Initialize variables to track download progress
  int downloaded = 0;
  List<List<int>> chunks = [];

  try {
    // Parse the URL
    final url = Uri.parse(fileUrl);

    // Create a GET request
    var request = new http.Request('GET', url);

    // Send the request and listen for the response
    var response = http.Client().send(request);

    // Listen to the response stream
    response.asStream().listen(
      (http.StreamedResponse r) {
        r.stream.listen(
          (List<int> chunk) {
            // Add the chunk to the list of chunks
            chunks.add(chunk);

            // Update the downloaded bytes and send the progress through the sendPort
            downloaded += chunk.length;
            sendPort.send("${(downloaded / r.contentLength!)}");
          },
          onDone: () async {
            // Send the final progress through the sendPort
            sendPort.send("${(downloaded / r.contentLength!)}");

            // Save the file
            File file = new File(downloadLocation);
            final Uint8List bytes = Uint8List(r.contentLength!);
            int offset = 0;
            for (List<int> chunk in chunks) {
              bytes.setRange(offset, offset + chunk.length, chunk);
              offset += chunk.length;
            }
            await file.create(recursive: true).then(
                (value) => file.writeAsBytes(bytes, mode: FileMode.append));
          },
          onError: (_) {
            // Send a message through the sendPort in case of error
            sendPort.send("download fail");
          },
        );
      },
      onError: (_) {
        // Send a message through the sendPort in case of error
        sendPort.send("download fail");
      },
    );
  } catch (e) {
    // Print any exceptions and send a message through the sendPort indicating download failure
    print(e.toString());
    sendPort.send("download fail");
  }
}
