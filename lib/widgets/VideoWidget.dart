import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digividya/widgets/LikeDialog.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/QuiteVideoPlayerDialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

// Define a StatefulWidget class named videoWidget
// ignore: must_be_immutable
class videoWidget extends StatefulWidget {
  // Declare a string variable for the video file name
  String VideoFile = "";
  int minutes;
  int seconds;
  int section = 0;
  int topicNumber = 0;
  int topicCount = 0;
  int subTopicNumber = 0;
  int subTopicCount = 0;
  int itemPointer = 0;
  // Declare a list of dynamic type for content URLs
  List<dynamic> contentUrls;
  // Declare a list of strings for file names
  List<String> FileName;

  // Constructor to initialize the variables
  videoWidget(
      {super.key,
      required this.VideoFile, // Initialize the video file name
      required this.minutes, // Initialize the minutes
      required this.seconds, // Initialize the seconds
      required this.section, // Initialize the section
      required this.topicNumber, // Initialize the topic number
      required this.topicCount, // Initialize the topic count
      required this.subTopicNumber, // Initialize the sub-topic number
      required this.subTopicCount, // Initialize the sub-topic count
      required this.itemPointer, // Initialize the item pointer
      required this.contentUrls, // Initialize the content URLs
      required this.FileName // Initialize the file names
      });
  // Override the createState method to create the state for the widget
  @override
  State<videoWidget> createState() => _videoWidgetState(
      VideoFile: VideoFile, // Pass the video file name to the state
      minutes: minutes, // Pass the minutes to the state
      seconds: seconds, // Pass the seconds to the state
      section: section, // Pass the section to the state
      topicNumber: topicNumber, // Pass the topic number to the state
      topicCount: topicCount, // Pass the topic count to the state
      subTopicNumber: subTopicNumber, // Pass the sub-topic number to the state
      subTopicCount: subTopicCount, // Pass the sub-topic count to the state
      contentUrls: contentUrls, // Pass the content URLs to the state
      FileName: FileName, // Pass the file names to the state
      itemPointer: itemPointer // Pass the item pointer to the state
      );
}

// Define a private state class for videoWidget
class _videoWidgetState extends State<videoWidget> with WidgetsBindingObserver {
  // Declare a late-initialized variable for the VideoPlayerController
  late VideoPlayerController videoPlayerController;
  // Declare a late-initialized variable for the ChewieController
  late ChewieController _chewieController;

  // Declare a string variable to store the video file name
  String VideoFile = "";
  // Declare integer variables to store the video duration in minutes and seconds
  int minutes;
  int seconds;
  // Declare integer variables for section, topic, sub-topic, and item pointers with initial values
  int section = 0;
  int topicNumber = 0;
  int topicCount = 0;
  int subTopicNumber = 0;
  int subTopicCount = 0;
  int itemPointer = 0;
  // Declare a list of dynamic type to store content URLs
  List<dynamic> contentUrls;
  // Declare a list of strings to store file names
  List<String> FileName;
  // Declare a list of strings to store device file names
  List<String> deviceFileName = [];
  // Declare a list of strings to store device file paths
  List<String> deviceFilePath = [];
  // Declare a ValueNotifier to track the state of the heart button, initially set to false
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);
  // Declare a variable to store the page context
  var pageContext;

  String directory = "";
  // Constructor to initialize the state variables
  _videoWidgetState(
      {required this.VideoFile,
      required this.minutes,
      required this.seconds,
      required this.section,
      required this.topicNumber,
      required this.topicCount,
      required this.subTopicNumber,
      required this.subTopicCount,
      required this.contentUrls,
      required this.FileName,
      required this.itemPointer});
  @override
  void initState() {
    super.initState();

    // Add this State object as an observer to the WidgetsBinding
    WidgetsBinding.instance.addObserver(this);

    // Call the method to get device file names
    _getDeviceFileName();

    //widget.VideoFile
    // Initialize the VideoPlayerController with the provided file
    videoPlayerController = VideoPlayerController.file(File(widget.VideoFile));

    // Initialize the ChewieController with settings for video playback
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        allowFullScreen: true,
        // Set the starting time of the video based on provided minutes and seconds
        startAt: ((widget.minutes != 0) && (widget.seconds != 0))
            ? Duration(minutes: widget.minutes, seconds: widget.seconds)
            : const Duration(minutes: 00),
        // Set the aspect ratio of the video player
        aspectRatio: 763 / 1640);
    // Add a listener to the VideoPlayerController for video playback events
    videoPlayerController.addListener(_videoListener);
  }

  @override
  Widget build(BuildContext context) {
    // Assign the context of the current page to pageContext
    pageContext = context;

    getDirectory();

    // Start downloading the next content file if there is more than one content URL and it's not the last content
    (contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : _startDownload(FileUrl: contentUrls[itemPointer + 1]);

    // Return a Scaffold widget wrapped in a PopScope
    return PopScope(
      // Disable popping this widget from the navigation stack
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            // Define flexible space for the app bar
            // height: MediaQuery.of(context).size.height * 0.,
            width: MediaQuery.of(context).size.width * 1,
          ),
          leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button to handle navigation
                BackButton(
                  onPressed: () {
                    _onBackPressed();
                  },
                ),
                Expanded(child: Text("Back"))
              ]),
          leadingWidth: MediaQuery.of(context).size.width * 1,
        ),
        body: SafeArea(
          // Display the video player wrapped in a SafeArea
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }

  // Define a method to handle the back button press event
  Future<bool> _onBackPressed() async {
    // Show a dialog to confirm whether to exit the video
    return (await showDialog(
          // Configure the dialog
          context: context,
          barrierDismissible:
              false, // Prevent dismissing the dialog by tapping outside
          barrierColor:
              Color.fromARGB(226, 37, 37, 37), // Set the color of the barrier
          builder: (context) {
            // Build the dialog content
            var exitVideoContext = context;
            // Return a quiteVideoPlayerDialog widget
            return quiteVideoPlayerDialog(
              yesButton: () {
                // Action to perform when the yes button is pressed
                print("**************** backButton pressed ****************");
                // Delay the navigation to give some time for the action to complete
                Future.delayed(
                  Duration(milliseconds: 300),
                  () {
                    // Navigate to the subTopicPage passing necessary arguments
                    Navigator.pushReplacementNamed(pageContext, "/subTopicPage",
                        arguments: {
                          "section": widget.section,
                          "topic": widget.topicNumber,
                          "topicCount": widget.topicCount,
                          "subTopicCount": widget.subTopicCount,
                        });
                    print("Navigate to subTopic page");
                  },
                );
                Navigator.pop(exitVideoContext);
                // Return true to indicate the action is completed
                return true;
              },
              // Action to perform when the no button is pressed
              noButton: () {
                // Close the dialog without performing any action
                Navigator.pop(exitVideoContext, false);
              },
            );
          },
        )) ?? // If showDialog returns null, return false
        false;
  }

  // Define a method to play content based on its type
  void _playContent(
      {required List<dynamic> contentUrls,
      required List<String> fileName,
      required int itemPointer}) async {
    print(
        "=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=> Item Pinter : ${itemPointer} =>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>");
    // Determine the type of content and take appropriate actions
    switch ((contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : contentUrls[itemPointer + 1]
            .toString()
            .split("/")
            .last
            .split(".")
            .last) {
      // If the content is an mp4 video
      case "mp4":
        print(
            "<<<<<<<<<<<<<<<<<< This Url Contains Mp4 Extension >>>>>>>>>>>>>>>>>>>>>");
        print(
            "%%%%%%%%%%%%%%%%%% The Directory Selected : ${directory} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

        // Navigate to the videoPage passing necessary arguments
        Navigator.pushReplacementNamed(context, '/vidoePage', arguments: {
          "filePath":
              "$directory/DigiVidya/Section_${section}/VideoFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Video/${fileName[itemPointer + 1]}",
          "minutes": 0,
          "seconds": 0,
          "section": section,
          "topic": topicNumber,
          "topicCount": topicCount,
          "subTopic": subTopicNumber,
          "subTopicCount": subTopicCount,
          "contentUrls": contentUrls,
          "itemPointer": itemPointer + 1,
          "FileName": FileName
        });
        break;
      // If the content is a zip file (likely containing an assessment)
      case "zip":
        print(
            "<<<<<<<<<<<<<<<< This Url Contains Zip Extension >>>>>>>>>>>>>>>>>>>>>>");
        print(
            "%%%%%%%%%%%%%%%%%% The Directory Selected : ${directory} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        // Define the directory path for the assessment content
        Directory AssessmentDirectroy = Directory(
            "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/");
        // Check if the assessment directory exists
        if (AssessmentDirectroy.existsSync()) {
          // Define the path for the assessment HTML file
          File htmlFile = File(
              "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story_html5.html");
          // Check if the HTML file exists
          if (htmlFile.existsSync()) {
            //play Assessment File
            Future.delayed(Duration(milliseconds: 300), () {
              // Navigate to the assessmentPage passing necessary arguments
              Navigator.pushReplacementNamed(context, '/assessmentPage',
                  arguments: {
                    "htmlFilePath": htmlFile.path.toString(),
                    "section": section,
                    "topic": topicNumber,
                    "topicCount": topicCount,
                    "subTopic": subTopicNumber,
                    "subTopicCount": subTopicCount,
                    "contentUrls": contentUrls,
                    "itemPointer": itemPointer + 1,
                    "FileName": FileName
                  });
            });
          } else {
            Future.delayed(Duration(milliseconds: 300), () {
              // Navigate to the assessmentPage passing necessary arguments
              Navigator.pushReplacementNamed(context, '/assessmentPage',
                  arguments: {
                    "htmlFilePath":
                        "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story.html",
                    "section": section,
                    "topic": topicNumber,
                    "topicCount": topicCount,
                    "subTopic": subTopicNumber,
                    "subTopicCount": subTopicCount,
                    "contentUrls": contentUrls,
                    "itemPointer": itemPointer + 1,
                    "FileName": FileName
                  });
            });
          }
        } else {
          // Define the path for the assessment zip file
          File AssessmentZipFile = File(
              "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1]}");
          // Check if the assessment zip file exists
          if (AssessmentZipFile.existsSync()) {
            // Extract the contents of the zip file
            ZipFile.extractToDirectory(
                    zipFile: AssessmentZipFile,
                    destinationDir: Directory(
                        "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/"))
                .then((_) async {
              // Define the path for the assessment HTML file
              File htmlFile = File(
                  "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story_html5.html");
              // Check if the HTML file exists
              if (htmlFile.existsSync()) {
                // Navigate to the assessmentPage passing necessary arguments
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.pushReplacementNamed(context, '/assessmentPage',
                      arguments: {
                        "htmlFilePath":
                            "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story_html5.html",
                        "section": section,
                        "topic": topicNumber,
                        "topicCount": topicCount,
                        "subTopic": subTopicNumber,
                        "subTopicCount": subTopicCount,
                        "contentUrls": contentUrls,
                        "itemPointer": itemPointer + 1,
                        "FileName": FileName
                      });
                });
              } else {
                Future.delayed(Duration(milliseconds: 300), () {
                  // Navigate to the assessmentPage passing necessary arguments
                  Navigator.pushReplacementNamed(context, '/assessmentPage',
                      arguments: {
                        "htmlFilePath":
                            "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story.html",
                        "section": section,
                        "topic": topicNumber,
                        "topicCount": topicCount,
                        "subTopic": subTopicNumber,
                        "subTopicCount": subTopicCount,
                        "contentUrls": contentUrls,
                        "itemPointer": itemPointer + 1,
                        "FileName": FileName
                      });
                });
              }
            });
          }
        }

        break;
      default:
        print(
            "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< From switch case of default >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        // Default case
        Future.delayed(Duration(milliseconds: 300), () {
          // Navigate to the bannerAd page
          Navigator.pushReplacementNamed(context, "/bannerAd", arguments: {
            "section": section,
            "topic": topicNumber,
            "topicCount": topicCount,
            "subTopicCount": subTopicCount
          });
        });
    }
  }

  _startDownload({required String FileUrl}) async {
    // Check if the URL is for an mp4 file
    if (FileUrl.toString().split("/").last.split(".").last == "mp4") {
      // for .mp4 Extension "http://192.168.1.19/prachi/DigiVidyaAPI/public/$fileUrl"
      // String Url = "http://192.168.1.19/prachi/DigiVidyaAPI/public/$FileUrl";
      // Construct the URL for the mp4 file
      String Url = "https://digividya.in/DigiVidyaAPI/laravel/public/$FileUrl";

      // Define the path for the video file
      File videoFile = File(
          "$directory/DigiVidya/Section_${section}/VideoFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Video/${FileName[itemPointer + 1]}");

      // Check if the video file does not exist
      if (!videoFile.existsSync()) {
        // Create a receive port for the main thread
        ReceivePort mainThreadReceiver = ReceivePort();

        // Spawn an isolate to download the content
        await Isolate.spawn(_downloadContent, {
          "url": Url,
          "location": videoFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listen for messages from the isolate
        mainThreadReceiver.listen((message) {
          if (message is String) {
            // Check if the message is not empty and does not indicate download failure
            if (message.isNotEmpty && (message.toString() != "download fail")) {
              print("$message % Downloaded");
            } else {
              // Show an error dialog for low internet connection
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  var dialogContext = context;
                  return InternetErrorDialog(
                    internetErrorDialogContext: dialogContext,
                    message:
                        "Low internet connection . Please check your internet connection .",
                  );
                },
              );
              print("Download Fail");
            }
          }
        });
      } else {
        ///
      }
    } else {
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

      String _directory = "";

      (deviceInfo.version.sdkInt < 33)
          ? (Directory((await getDownloadsDirectory())!.path).existsSync())
              ? _directory = (await getDownloadsDirectory())!.path
              : Directory((await getDownloadsDirectory())!.path)
                  .create(recursive: true)
                  .then((value) {
                  _directory = value.path.toString();
                })
          : _directory = (await getApplicationSupportDirectory()).path;
      //For .zip Extension
      // String Url =
      // "http://192.168.1.19/prachi/DigiVidyaAPI/public/$FileUrl";
      String Url = "https://digividya.in/DigiVidyaAPI/laravel/public/$FileUrl";

      File AssessmentZipFile = File(
          "$_directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1]}");
      // Old Assessment file deletion operation
      if (!AssessmentZipFile.existsSync()) {
        // Check if the next item in FileName is different from the current item in deviceFileName
        // and ensure both FileName and deviceFileName are not empty

        if ((FileName.isNotEmpty && deviceFileName.isNotEmpty)) {
          if ((FileName[itemPointer + 1] != deviceFileName[itemPointer])) {
            // Print a message indicating that the assignment file is updated
            print(
                "%%%%%%%%%%%%%%%%%%%%%% Assignment File is Updated %%%%%%%%%%%%%%%%%%%%%%%%%%%%");

            // Check if the file at the given path exists
            if (File(deviceFilePath[itemPointer].toString()).existsSync()) {
              // Delete the existing file and proceed with the following actions
              File(deviceFilePath[itemPointer].toString())
                  .delete()
                  .then((_) async {
                // Print a message indicating that the old assignment file is deleted
                print(
                    "%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Old Assignment File is Deleted %%%%%%%%%%%%%%%%%%%%%%%");

                // Create a ReceivePort to receive messages from the spawned Isolate
                ReceivePort mainThreadReceiver = ReceivePort();

                // Spawn an Isolate to download the content
                await Isolate.spawn(_downloadContent, {
                  "url": Url, // URL of the content to be downloaded
                  "location": AssessmentZipFile
                      .path, // Location to save the downloaded content
                  "sendPort": mainThreadReceiver
                      .sendPort // Port to communicate with the main thread
                });

                // Listen to messages from the spawned Isolate
                mainThreadReceiver.listen((message) {
                  if (message is String) {
                    // Check if the message is not empty and not indicating a download failure
                    if (message.isNotEmpty &&
                        message.toString() != "download fail") {
                      // Print messages indicating the progress of the assessment file download

                      debugPrint('downloadPercentage: ${message}');
                    } else {
                      // Show a dialog for internet error if the download fails
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          var dialogContext = context;
                          // Return an InternetErrorDialog with the appropriate message
                          return InternetErrorDialog(
                            internetErrorDialogContext: dialogContext,
                            message:
                                "Low internet connection. Please check your internet.",
                          );
                        },
                      );

                      // Print a message indicating download failure
                      print("Download Fail");
                    }
                  }
                });
              });
            }
          } else {
            // Create a ReceivePort to receive messages from the spawned Isolate
            ReceivePort mainThreadReceiver = ReceivePort();

            // Spawn an Isolate to download the content
            await Isolate.spawn(_downloadContent, {
              "url": Url, // URL of the content to be downloaded
              "location": AssessmentZipFile
                  .path, // Location to save the downloaded content
              "sendPort": mainThreadReceiver
                  .sendPort // Port to communicate with the main thread
            });

            // Listen to messages from the spawned Isolate
            mainThreadReceiver.listen((message) {
              if (message is String) {
                // Check if the message is not empty and not indicating a download failure
                if (message.isNotEmpty &&
                    message.toString() != "download fail") {
                  // Print messages indicating the progress of the assessment file download

                  debugPrint('downloadPercentage: ${message}');
                } else {
                  // Show a dialog for internet error if the download fails
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      var dialogContext = context;
                      // Return an InternetErrorDialog with the appropriate message
                      return InternetErrorDialog(
                        internetErrorDialogContext: dialogContext,
                        message:
                            "Low internet connection. Please check your internet.",
                      );
                    },
                  );

                  // Print a message indicating download failure
                  print("Download Fail");
                }
              }
            });
          }
        } else {
          // Create a ReceivePort to receive messages from the spawned Isolate
          ReceivePort mainThreadReceiver = ReceivePort();

          // Spawn an Isolate to download the content
          await Isolate.spawn(_downloadContent, {
            "url": Url, // URL of the content to be downloaded
            "location": AssessmentZipFile
                .path, // Location to save the downloaded content
            "sendPort": mainThreadReceiver
                .sendPort // Port to communicate with the main thread
          });

          // Listen to messages from the spawned Isolate
          mainThreadReceiver.listen((message) {
            if (message is String) {
              // Check if the message is not empty and not indicating a download failure
              if (message.isNotEmpty && message.toString() != "download fail") {
                // Print messages indicating the progress of the assessment file download

                debugPrint('downloadPercentage: ${message}');
              } else {
                // Show a dialog for internet error if the download fails
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var dialogContext = context;
                    // Return an InternetErrorDialog with the appropriate message
                    return InternetErrorDialog(
                      internetErrorDialogContext: dialogContext,
                      message:
                          "Low internet connection. Please check your internet.",
                    );
                  },
                );

                // Print a message indicating download failure
                print("Download Fail");
              }
            }
          });
        }
      }
    }
    return;
  }

  // Override the dispose method to release resources when the widget is disposed
  @override
  void dispose() {
    // Call the superclass's dispose method
    super.dispose();
    // FileName.clear();
    // contentUrls.clear();
    // Dispose the video player controller
    videoPlayerController.dispose();
    // Dispose the Chewie controller
    _chewieController.dispose();
    // Remove this widget's observer from the WidgetsBinding instance
    WidgetsBinding.instance.removeObserver(this);
  }

// Function to show the like dialog
  void _showLikeDialog() {
    // Show a dialog with options for liking or disliking
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Store the context of the dialog box
        var LikeDialogBoxContext = context;
        return LikeDialog(
          // Action for the like button
          yesButton: () {
            // Set the heart button pressed value to true
            heartButtonPressed.value = true;
            // Delay to simulate like action
            Future.delayed(
              Duration(milliseconds: 60),
              () {
                _likeSubTopic(); // Perform like action
              },
            );
            // Delay to close the dialog
            Future.delayed(
              Duration(seconds: 2),
              () {
                Navigator.of(LikeDialogBoxContext).pop();
              },
            );
          },
          // Action for the dislike button
          noButton: () async {
            // Get the application support directory path

            // Read app info JSON file
            File jsonFile = File("$directory/appInfo.json");
            var jsonData = jsonDecode(jsonFile.readAsStringSync());
            String user_Id = jsonData['User_Id'].toString();
            String subTopic_Id = jsonData['subTopic_Id'].toString();
            // _setCompletedSubTopic(user_Id: user_Id, subTopic_Id: subTopic_Id)
            // Call method to set subtopic as completed for demo user
            _demouserprogress(
              user_Id: user_Id,
              subTopic_Id: subTopic_Id,
              topic_Id: topicNumber.toString(),
            ).then((_) {
              Future.delayed(
                Duration(milliseconds: 600),
                () {
                  //Navigate to Banner add Page
                  Navigator.pushReplacementNamed(pageContext, "/bannerAd",
                      arguments: {
                        "section": section,
                        "topic": topicNumber,
                        "topicCount": topicCount,
                        "subTopicCount": subTopicCount
                      });
                },
              );
            });
            // Close the dialog
            Navigator.of(LikeDialogBoxContext).pop();
          },
          // Pass the value notifier for heart button state
          heartButtonPressed: heartButtonPressed,
        );
      },
    );
  }

  // Method to like a subtopic
  _likeSubTopic() async {
    // Read app info JSON file
    File jsonFile = File("$directory/appInfo.json");

    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    try {
      // Extract user ID and subtopic ID from JSON data
      String user_Id = jsonData['User_Id'].toString();
      String subTopic_Id = jsonData['subTopic_Id'].toString();
      // Prepare user data to send to API
      var sendUserData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
      // API URL for storing likes for subtopic
      String api_Url =
          "https://digividya.in/DigiVidyaAPI/api/storeLikesForSubtopic";

      // String api_Url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/storeLikesForSubtopic";
      // Send POST request to API
      var response = await http.post(Uri.parse(api_Url), body: sendUserData);

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse response JSON
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%% ${jsonResponse['status']} %%%%%%%%%%%%%%%%%%%%%%%%%%");

        // Check if status is true
        if (jsonResponse['status']) {
          // Clear subtopic ID from JSON data
          jsonData['subTopic_Id'] = "";
          // Write updated JSON data to file
          jsonFile.writeAsStringSync(jsonEncode(jsonData));

          // _setCompletedSubTopic(user_Id: user_Id, subTopic_Id: subTopic_Id)
          // Call method to set subtopic as completed for demo user
          _demouserprogress(
            user_Id: user_Id,
            subTopic_Id: subTopic_Id,
            topic_Id: topicNumber.toString(),
          ).then((_) {
            Future.delayed(
              Duration(milliseconds: 600),
              () {
                Navigator.pushReplacementNamed(context, "/bannerAd",
                    arguments: {
                      "section": section,
                      "topic": topicNumber,
                      "topicCount": topicCount,
                      "subTopicCount": subTopicCount
                    });
              },
            );
          });
        } else {
          // Delay and navigate to banner ad page
          Future.delayed(
            Duration(milliseconds: 600),
            () {
              Navigator.pushReplacementNamed(context, "/bannerAd", arguments: {
                "section": section,
                "topic": topicNumber,
                "topicCount": topicCount,
                "subTopicCount": subTopicCount
              });
            },
          );
        }
      } else {
        // Show internet error dialog if request fails
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var internetErrorDialogContext = context;
            return InternetErrorDialog(
              internetErrorDialogContext: internetErrorDialogContext,
              message: "Low internet connection . Please check your internet.",
            );
          },
        );
      }
    } // Handle HTTP client exceptions
    on http.ClientException catch (e) {
      // Show internet error dialog and print error message
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var internetErrorDialogContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorDialogContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
      print("This Occured when Client Exception Happen.. :${e.toString()}");
    } // Handle other exceptions
    on Exception catch (e) {
      // Show internet error dialog and print error message
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var internetErrorDialogContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorDialogContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
      print("This Occured when any Exception happen : ${e.toString()}");
    }
  }

  // insted of _setcompletedtopic using _demouserprogress
  // Method to update demo user progress
  _demouserprogress({
    required user_Id,
    required subTopic_Id,
    required topic_Id,
    // required section_Id
  }) async {
    // API URL for inserting user progress
    String Api_url = "https://digividya.in/DigiVidyaAPI/api/insertUserProgress";
    // Prepare user data to send to API
    var userData = {
      "user_id": user_Id,
      "subtopic_id": subTopic_Id,
      "topic_id": topic_Id,
      // "section_id": section_Id
    };
    // Send HTTP POST request to API
    var response = await http.post(Uri.parse(Api_url), body: userData);
    if (response.statusCode == 200) {
      print("${response.body.replaceAll("\n", " ")}");
    }
  }

  void _videoListener() async {
    // Get the total duration of the video
    Duration _totalDuration = videoPlayerController.value.duration;
    // Get the current position of the video progress indicator
    Duration _currentPositionOfProgressIndicator =
        videoPlayerController.value.position;
    // Check if the video has reached or exceeded its total duration
    if (_currentPositionOfProgressIndicator == _totalDuration ||
        _currentPositionOfProgressIndicator >= _totalDuration) {
      // Check if the current item is not the last one in the contentUrls list
      if (itemPointer != contentUrls.length - 1) {
        // Check if the current video file exists
        if (File(widget.VideoFile).existsSync()) {
          // Delete the current video file
          await File(widget.VideoFile).delete(recursive: true).then((_) {
            _chewieController.exitFullScreen();
/////////////////////////////////////////////////////////////////////////////////////////////////////

            // Play the next content
            _playContent(
                contentUrls: contentUrls,
                fileName: FileName,
                itemPointer: (itemPointer));
          });
          // Exit full screen mode

          print(
              "From If Block the $FileName ,Content :$contentUrls , itemPointer : $itemPointer");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        } else {
          // Exit full screen mode
          _chewieController.exitFullScreen();
          print(
              "From else Block the $FileName ,Content :$contentUrls , itemPointer : $itemPointer");

          // Play the next content
          _playContent(
              contentUrls: contentUrls,
              fileName: FileName,
              itemPointer: (itemPointer));
        }
      } else {
        print(
            "Exit to Video Page >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

        print(
            "=>=>=>=>=>=>=>=>=>=>=>=>=> From File Exit =>=>=>=>=>=>=>=>=>=>=>=>=>");

        // Delete the current video file
        File(widget.VideoFile).deleteSync(recursive: true);
        // Exit full screen mode
        _chewieController.exitFullScreen();
        // Remove the video listener
        videoPlayerController.removeListener(_videoListener);
        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        // Show the like dialog
        _showLikeDialog();
      }
    } else {
      // If the video is still playing, delay for 20 seconds and then print a message
      Future.delayed(
        Duration(seconds: 20),
        () {
          print(
              "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $contentUrls %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        },
      );

      print("Currently Video Is Playing => => => =>");
    }
  }

  _getDeviceFileName() async {
    // Check if the assessment directory exists for the current section, topic, and subtopic
    if (Directory(
            "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/")
        .existsSync()) {
      // List all files and directories in the assessment directory
      Directory(
              "$directory/DigiVidya/Section_${section}/AssignmentFiles/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/")
          .listSync()
          .forEach((element) {
        // Add the file name to deviceFileName list
        deviceFileName.add(element.path.split("/").last.toString());
        // Add the file path to deviceFilePath list
        deviceFilePath.add(element.path.toString());
      });
    }

    // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  $deviceFileName  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  }

  void getDirectory() async {
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    if (deviceInfo.version.sdkInt < 33) {
      if (Directory((await getDownloadsDirectory())!.path).existsSync()) {
        setState(() async {
          directory = (await getDownloadsDirectory())!.path;
        });
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

void _downloadContent(Map<String, dynamic> message) {
  // Extract the URL to download from the message
  String fileUrl = message["url"].toString();
  // Extract the location to save the downloaded file from the message
  String downloadLocation = message['location'].toString();
  // Extract the SendPort from the message to communicate with the main isolate
  final sendPort = message['sendPort'] as SendPort;
  // Initialize the variable to track the amount downloaded
  int downloaded = 0;
  // Initialize a list to store the chunks of downloaded data
  List<List<int>> chunks = [];

  try {
    // Parse the URL
    final url = Uri.parse(fileUrl);
    // Create an HTTP GET request
    var request = new http.Request('GET', url);
    // Send the HTTP request
    var response = http.Client().send(request);
    // Listen to the response stream
    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Add the received chunk to the list of chunks
        chunks.add(chunk);
        // Update the amount downloaded
        downloaded += chunk.length;
        // Send the current download percentage to the main isolate
        sendPort.send("${(downloaded / r.contentLength!)}");
        print(
            "%%%%%%%%%%%%%%%%%%% Download Location : $downloadLocation %%%%%%%%%%%%%%%%%%%%%%%");
      }, onDone: () async {
        // Send the final download percentage to the main isolate
        sendPort.send("${(downloaded / r.contentLength!)}");
        // Save the file
        // Create the file at the download location
        File file = new File(downloadLocation);
        // Create a byte buffer to store the downloaded data
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        // Copy the chunks into the byte buffer
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        // Write the byte buffer to the file
        await file
            .create(recursive: true)
            .then((value) => file.writeAsBytes(bytes, mode: FileMode.append));
      }, onError: (_) {
        // Send a "download fail" message if an error occurs while downloading
        sendPort.send("download fail");
      });
    }, onError: (_) {
      // Send a "download fail" message if an error occurs with the response
      sendPort.send("download fail");
    });
  } catch (e) {
    // Print the error message to the console
    print(e.toString());
    // Send a "download fail" message if an exception is caught
    sendPort.send("download fail");
  }
}
