// import 'package:audioplayers/audioplayers.dart';
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/Routes/Applink.dart';
import 'package:digividya/widgets/InternalserverError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/Lock_Cards.dart';
import 'package:digividya/widgets/commingSoonAlertBox.dart';
import 'package:digividya/widgets/exitAppDialog.dart';
import 'package:digividya/widgets/resumeAndPlayDialog.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// ignore: camel_case_types

class sectionPage extends StatefulWidget {
  sectionPage({super.key});

  @override
  State<sectionPage> createState() => _sectionPageState();
}

// ignore: camel_case_types
class _sectionPageState extends State<sectionPage> with WidgetsBindingObserver {
  final FixedExtentScrollController _fixedExtentScrollController =
      FixedExtentScrollController();
  Connectivity _connectivity = Connectivity();
  ValueNotifier<dynamic> dataFatched = ValueNotifier(false);
  ValueNotifier<bool> progressOfSection = ValueNotifier<bool>(false);
  int sectionCount = 0, topicCount = 0, sectionId = 0;
  double progressData = 0.0;
  String sectionTitle = "",
      sectionDescription = "",
      sectionCardImage = "",
      image = "",
      UserName = "";
  List<dynamic> sectionDetail = [];
  List<String> cardsAudioFilePath = [];
  List<dynamic> deviceAudioFileName = [];
  List<String> updatedAudioFileName = [];
  List<String> listFileNameFromServer = [];
  List<double> _sectionProgress = [];
  // Map<String, dynamic> sectionLikes = {};
  // Map<String, dynamic> sectionView = {};
  Map<String, dynamic> cardImage = {};
  Map<String, dynamic> cardsAudio = {};
  Map<String, dynamic> progressOfEachSection = {};
  List<dynamic> sectionIds = [];
  List<dynamic> imageByteData = [];
  List<String> cardsTitle = [];
  List<String> cardsLike = [];
  List<String> cardsView = [];
  List<String> _sectionId = [];
  List<String> _topicCount = [];
  List<int> SectionSTopicCount = [];
  List<bool> _getCompletedSectionBoolValue = [];
  late bgAudioPlayer player;
  late ConcatenatingAudioSource playList;
  ScreenshotController _screenshotController = ScreenshotController();

// Override the initState method to initialize the state of the widget
@override
void initState() {
  super.initState(); // Call the superclass's initState method

  // Add this widget as an observer to the WidgetsBinding instance
  WidgetsBinding.instance.addObserver(this);

  // Call the _ShowHoldSession method to presumably handle session-related initialization
  _ShowHoldSession();

  // Check the device's connectivity status
  _checkConnectivity();

  // Add a listener to the fixed extent scroll controller
  // The onScroll method will be called whenever the scroll position changes
  _fixedExtentScrollController.addListener(() {
    onScroll();
  });
}


// Override the build method to build the widget tree
@override
Widget build(BuildContext context) {
  // If _getCompletedSectionBoolValue and _sectionProgress are both empty, 
  // call _generateTempBoolValue; otherwise, do nothing
  (_getCompletedSectionBoolValue.isEmpty && _sectionProgress.isEmpty)
      ? _generateTempBoolValue()
      : () {};

  // Check for the availability of an app link
  _checkApplinkAvail();

  // Return the widget tree
  return PopScope(
    canPop: false, // Disable popping from the navigation stack
    onPopInvoked: (didPop) {}, // Callback when a pop is invoked (no action here)
    child: Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: dataFatched, // Listen to changes in dataFatched
          builder: (context, value, child) {
            if (value is bool) {
              // If dataFatched is a boolean
              if (value) {
                // If dataFatched is true
                return ValueListenableBuilder(
                  valueListenable: progressOfSection, // Listen to progressOfSection
                  builder: (context, value, child) {
                    if (value is bool) {
                      // If progressOfSection is a boolean
                      if (value) {
                        // If progressOfSection is true, return the topics widget wrapped in a Screenshot widget
                        return Screenshot(
                          controller: _screenshotController, 
                          child: topics()
                        );
                      } else {
                        // If progressOfSection is false, also return the topics widget wrapped in a Screenshot widget
                        return Screenshot(
                          controller: _screenshotController, 
                          child: topics()
                        );
                      }
                    } else {
                      // If progressOfSection is not a boolean, return the topics widget wrapped in a Screenshot widget
                      return Screenshot(
                        controller: _screenshotController, 
                        child: topics()
                      );
                    }
                  },
                );
              } else {
                // If dataFatched is false, show a loading indicator with a message
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.115,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        child: Text(
                          "Please wait while loading..",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "mainFont",
                            fontSize: 15,
                            decoration: TextDecoration.none
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              // If dataFatched is not a boolean, show a loading indicator
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}


// Define a widget to generate a list of topic cards
Widget topics() {
  List<Widget> topic = []; // Initialize an empty list to hold topic widgets
  Map<int, dynamic> keys = {}; // Create a map to hold unique keys for each topic

  // Generate unique keys for each section
  for (int i = 0; i < sectionCount; i++) {
    keys[i] = UniqueKey();
  }

  // Loop through each section and create a Card widget
  for (int i = 0; i < sectionCount; i++) {
    topic.add(
      Card(
        shadowColor: Colors.black,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04
        ),
        elevation: 25,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(58),
        ),
        child: Stack(
          children: [
            // Background image container
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(58),
                image: DecorationImage(
                  image: MemoryImage(imageByteData[i]), 
                  fit: BoxFit.fill
                ),
              ),
            ),
            // Completion animation
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              right: MediaQuery.of(context).size.width * 0.232,
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Visibility(
                visible: _getCompletedSectionBoolValue[i],
                child: LottieBuilder.asset(
                  "assets/Animation/9kASTq22vM.json",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
            ),
            // Section title and interaction buttons
            Positioned(
              top: MediaQuery.of(context).size.height * 0.40,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05
                      ),
                      child: Text(
                        cardsTitle[i],
                        style: TextStyle(
                          fontSize: 25, 
                          fontWeight: FontWeight.bold
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/app_icons/heart.png',
                                height: 30,
                                width: 50,
                              ),
                              Text("${cardsLike[i]}")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/app_icons/ViewIcon.webp',
                                height: 30,
                                width: 50,
                              ),
                              Text("${cardsView[i]}")
                            ],
                          ),
                          // Share button
                          IconButton(
                            onPressed: () async {
                              File sectionImage = File(
                                "${(await getApplicationSupportDirectory()).path}/Section${sectionId}/Section${sectionId}.png"
                              );
                              final Userdata = {
                                "section": sectionId.toString(),
                                "topic_count": sectionDetail[i]['topic_count'].toString()
                              };
                              final uri = Uri.https("digividya.in", "/topicpage.php", Userdata);
                              if (!sectionImage.existsSync()) {
                                _screenshotController.capture().then((value) async {
                                  sectionImage.createSync(recursive: true, exclusive: true);
                                  await sectionImage.writeAsBytes(value!).then((value) {
                                    shareSection(uri.toString(), sectionImage.path);
                                  });
                                });
                              }
                            },
                            icon: Icon(Icons.share)
                          ),
                        ],
                      ),
                    ),
                    // Start button
                    GestureDetector(
                      onTap: () async {
                        (sectionDetail[i]['topic_count'] != 0) ? player.stopAudio() : {};

                        setState(() {
                          // Navigator.of(context).pushReplacementNamed('/TopicPage',
                          // arguments: {
                          // 'section': sectionId,
                          // 'topic_count': sectionDetail[i]['topic_count']
                          // })
                        });

                        (UserName == "Guest" && i != 0)
                          ? showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              var LockCardContext = context;
                              return lockcard(
                                LockCardDialogContext: LockCardContext
                              );
                            },
                          )
                          : (sectionDetail[i]['topic_count'] != 0)
                            ? Navigator.of(context).pushNamed('/TopicPage', arguments: {
                              'section': sectionId,
                              'topic_count': sectionDetail[i]['topic_count']
                            })
                            : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                var comingSoonContext = context;
                                return commingSoonAlertbox(
                                  comingSoonDialogContext: comingSoonContext
                                );
                              },
                            );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.45,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.005,
                          bottom: MediaQuery.of(context).size.height * 0.005
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(3, 45, 96, 1),
                              Color.fromRGBO(1, 118, 211, 1),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)
                          )
                        ),
                        child: const Center(
                          child: Text(
                            "START",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            // Progress indicator
            Positioned(
              top: MediaQuery.of(context).size.height * 0.038,
              left: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.055,
                width: MediaQuery.of(context).size.height * 0.055,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Colors.white,
                  color: Color.fromRGBO(0, 208, 255, 1),
                  value: !_sectionProgress[i].isNaN ? _sectionProgress[i] : 0.0,
                ),
              ),
            ),
            // Progress percentage text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.053,
              left: MediaQuery.of(context).size.width * 0.77,
              child: Text(
                "${(!_sectionProgress[i].isNaN ? (_sectionProgress[i] * 100).round() : 0)} %",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Lock image for guest users
            (UserName == "Guest") ? (i != 0)
              ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/LockCardImage.webp"),
                    fit: BoxFit.fill
                  ),
                ),
              )
              : SizedBox()
            : SizedBox()
          ],
        ),
      )
    );
  }

  // Return a scrollable list of topic cards
  return ListWheelScrollView(
    physics: const FixedExtentScrollPhysics(),
    magnification: 1.0,
    itemExtent: 530,
    controller: _fixedExtentScrollController,
    children: topic
  );
}


// Method to handle scroll events and update the card details
onScroll() async {
  // Check if the user is scrolling in the reverse direction (upward)
  if ((_fixedExtentScrollController.position.userScrollDirection == ScrollDirection.reverse)) {
    // Schedule a callback to be executed after the current frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Update the section ID based on the currently selected item in the scroll controller
        sectionId = sectionDetail[_fixedExtentScrollController.selectedItem]['DS_ID'];

        // Play the next audio track using the player
        player.playNextTrack(nextTrackIndex: _fixedExtentScrollController.selectedItem);
      });
    });
    print("upward scrolling");
    print("Section ${_fixedExtentScrollController.selectedItem + 1} Audio File Name : ${listFileNameFromServer[_fixedExtentScrollController.selectedItem]}");
  } else {
    // If the user is scrolling in the forward direction (downward)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Update the section ID based on the currently selected item in the scroll controller
        sectionId = sectionDetail[_fixedExtentScrollController.selectedItem]['DS_ID'];

        // Play the previous audio track using the player
        player.playPreviousTrack(previousTrackIndex: _fixedExtentScrollController.selectedItem);
      });
    });
    // Commented out debug prints for reverse scrolling
    // print("revers scrolling");
    // print("Section ${_fixedExtentScrollController.selectedItem+1} Audio File Name : ${listFileNameFromServer[_fixedExtentScrollController.selectedItem]}");
  }
}


// Override the didChangeAppLifecycleState method to handle lifecycle changes
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  super.didChangeAppLifecycleState(state);

  // If the app is paused or detached, stop playing audio
  if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
    player.stopAudio();
  }

  // Uncomment the following block if you want to handle audio initialization when the app is resumed
  // if (state == AppLifecycleState.resumed) {
  //   player.initAudioPlayer();
  // }
}


// Override the dispose method to clean up resources when the widget is removed from the widget tree
void dispose() {
  // Clear various lists and maps used to manage section details, audio, images, and titles
  sectionDetail.clear();
  cardsAudioFilePath.clear();
  deviceAudioFileName.clear();
  updatedAudioFileName.clear();
  listFileNameFromServer.clear();
  // sectionLikes.clear(); // Uncomment if needed
  // sectionView.clear(); // Uncomment if needed
  cardImage.clear();
  cardsAudio.clear();
  sectionIds.clear();
  imageByteData.clear();
  cardsTitle.clear();
  cardsLike.clear();
  cardsView.clear();
  _sectionId.clear();
  _topicCount.clear();

  // Stop and dispose of the audio player
  // player.stopAudio(); // Uncomment if needed
  player.disposeAudio();

  // Remove any listeners from the scroll controller and dispose of it
  _fixedExtentScrollController.removeListener(() {});
  _fixedExtentScrollController.dispose();

  // Remove this widget as an observer of app lifecycle events
  WidgetsBinding.instance.removeObserver(this);

  // Call the super class dispose method to ensure proper disposal
  super.dispose();
}


// Method to fetch section details from an API and store user progress in a JSON file
getSectionDetails() async {
  // Get the path to the application support directory
  String dirPath = (await getApplicationSupportDirectory()).path;
  // API URL to fetch sections
  // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchSections";
  String url = "https://digividya.in/DigiVidyaAPI/api/fetchSections";

  // JSON file used for storing the progress and user details
  File jsonFile = File("$dirPath/appInfo.json");

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    var jsonData = jsonDecode(jsonFile.readAsStringSync());

    try {
      // Extract user details from JSON data
      UserName = jsonData['UserName'].toString();
      var userData = {'user_id': jsonData['User_Id'].toString()};

      // Make a POST request to the API with user data
      var response = await http.post(Uri.parse(url), body: userData);

      if (response.statusCode == 200) {
        // Parse and clean the response from the server
        var jsonRespons = jsonDecode(response.body.toString().replaceAll("\n", " "));

        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $jsonRespons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

        if (jsonRespons.isNotEmpty) {
          setState(() {
            // Update state with section details
            sectionCount = jsonRespons['section_count'];
            sectionDetail = jsonRespons['section_details'];
            sectionIds = jsonRespons['section_ids'];
            // sectionLikes = jsonRespons['section_likes'];
            // sectionView = jsonRespons['section_views'];
            cardImage = jsonRespons['section_img'];
            cardsAudio = jsonRespons['section_aud'];
            sectionTitle = sectionDetail[0]['DS_NAME'];
            sectionId = sectionDetail[0]['DS_ID'];
            topicCount = sectionDetail[0]['topic_count'];
          });

          // Convert image data from base64 and add to list
          cardImage.forEach((key, value) {
            imageByteData.add(Base64Decoder().convert(value));
          });

          // Populate card titles, likes, and views from section details
          sectionDetail.forEach((element) {
            cardsTitle.add(element['DS_NAME']);
          });
          sectionDetail.forEach((element) {
            cardsLike.add(element["likes_counts"].toString());
            cardsView.add(element["views_count"].toString());
            SectionSTopicCount.add(element["topic_count"]);
          });

          // Fetch section completion details
          _getSectionCompletedDetails();
          dataFatched.value = true;

          // Update JSON data with section ID and write back to file
          jsonData['section_id'] = sectionDetail[0]['DS_ID'];
          print(jsonData);
          jsonFile.writeAsStringSync(jsonEncode(jsonData));

          print(jsonFile.readAsStringSync());
        } else {
          // Handle empty response from server
        }
      } else {
        // Show dialog for poor connection or server error
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var InternalserverErrorContext = context;
            return InternalserverError(
              InternalserverErrorContext: InternalserverErrorContext,
              ErrorTitle: "Poor Connection",
               Description: " Maybe you have a poor internet connection. Please try again.",
              retryButton: () {
                getSectionDetails().then((_) {
                  Navigator.of(context).pop(InternalserverErrorContext);
                });
              },
              ButtonText: "try again",
            );
          },
        );
      }
    } on http.ClientException catch (e) {
      print("Exception From ${e.message}");
      final _checkConnectivity = await _connectivity.checkConnectivity();

      if (_checkConnectivity == ConnectivityResult.none) {
        // Show dialog for no internet connection
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var InternalserverErrorContext = context;
            return InternalserverError(
              InternalserverErrorContext: InternalserverErrorContext,
              ErrorTitle: "No Internet",
               Description: "Maybe you don't have internet connection. Please check and try again.",
              retryButton: () {
                Future.delayed(Duration(milliseconds: 50), () {
                  getSectionDetails();
                });
              },
              ButtonText: "reload",
            );
          },
        );
      } else {
        // Show dialog for poor connection
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var InternalserverErrorContext = context;
            return InternalserverError(
              InternalserverErrorContext: InternalserverErrorContext,
              ErrorTitle: "Poor Connection",
               Description: " Maybe you have a poor internet connection. Please try again.",
              retryButton: () {
                getSectionDetails().then((_) {
                  Navigator.of(context).pop(InternalserverErrorContext);
                });
              },
              ButtonText: "try again",
            );
          },
        );
      }
    }
  } else {
    // Handle case where JSON file does not exist
  }
  return;
}


// Method to handle the back button press and show a confirmation dialog
Future<bool> onBackButtonPress() async {
  // Show a dialog to confirm if the user wants to exit the app
  return (await showDialog(
    barrierDismissible: false, // Prevent dismissal by tapping outside the dialog
    context: context, // Provide the current context
    builder: (context) {
      var exitDialogContex = context; // Capture the dialog context
      // Return the custom exit dialog widget
      return exitAppDialog(dialogcontect: exitDialogContex);
    },
  )) ?? 
  // If the dialog is dismissed without a selection, return false
  false;
}


// Method to manage session resumption
_ShowHoldSession() async {
  // Get the application support directory path
  String DirPath = (await getApplicationSupportDirectory()).path;

  // Define the path to the JSON file that stores session information
  File jsonFile = File("$DirPath/appInfo.json");

  // Read and parse the JSON data from the file
  var jsonData = jsonDecode(jsonFile.readAsStringSync());

  // Check if the "ResumData" key exists in the JSON data
  if (!jsonData.containsKey("ResumData")) {
    // If "ResumData" does not exist, create a new structure for it
    Map resumeData = {
      "VideoData": {
        "contentType": "",
        "filePath": "",
        "sectionNumber": "",
        "totpicNumber": "",
        "topicCount": "",
        "subTopicNumber": "",
        "partNumber": "",
        "videoMinute": "",
        "videoSeconds": "",
        "totalVideo": "",
        "totalAssessment": "",
        "videoPlayedCount": "",
        "assessmentPlayed": ""
      },
      "AssessmentData": {
        "contentType": "",
        "filePath": "",
        "sectionNumber": "",
        "totpicNumber": "",
        "topicCount": "",
        "subTopicNumber": "",
        "partNumber": "",
        "totalVideo": "",
        "totalAssessment": "",
        "videoPlayedCount": "",
        "assessmentPlayed": ""
      }
    };
    // Add the new "ResumData" structure to the JSON data
    jsonData["ResumData"] = resumeData;
    // Write the updated JSON data back to the file
    jsonFile.writeAsStringSync(jsonEncode(jsonData));
  } else {
    // If "ResumData" already exists, check if it contains any valid file paths
    var startOver = jsonData['ResumData'];
    if (startOver['VideoData']['filePath'].toString().isEmpty &&
        startOver['AssessmentData']['filePath'].toString().isEmpty) {
      // If both file paths are empty, print a message indicating no data to resume
      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< resume Data is Empty >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    } else {
      // If there are valid file paths, show a dialog to allow the user to resume or start over
      showDialog(
        context: context,
        builder: (context) {
          // Return the custom resume and play dialog widget
          return resumeAndPlayDialog(resume: () {}, startOver: () {});
        },
      );
    }
  }
}


  // Method to check internet connectivity and handle offline scenarios
_checkConnectivity() async {
  // Check the current connectivity status
  final _checkConnectivity = await _connectivity.checkConnectivity();

  // If there is no internet connection
  if (_checkConnectivity == ConnectivityResult.none) {
    // Show a dialog informing the user about the lack of internet connection
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside the dialog
      context: context, // Provide the current context
      builder: (context) {
        var internetErrorContext = context; // Capture the dialog context
        // Return a custom internet error dialog widget
        return InternetErrorDialog(
          internetErrorDialogContext: internetErrorContext,
          message:
              "Looks like you might be offline. Please check your internet connection and try again.",
        );
      },
    );
  } else {
    // If there is an internet connection, proceed to get section details
    getSectionDetails().then((_) {
      // After getting section details, check for audio file updates
      getAudioFileUpdate().then((_) {
        // Create a playlist for playing cards audio
        playList = ConcatenatingAudioSource(
          useLazyPreparation: true, // Lazily prepare audio files
          children: List.generate(
            sectionCount,
            (index) => AudioSource.file(cardsAudioFilePath[index]),
          ),
        );

        // Initialize the audio player with the created playlist
        player = bgAudioPlayer(concatenatingAudioSource: playList);

        // Start playing the first card audio
        player.initAudioPlayer();
      });
    });
  }
}


// Method to update and manage audio files for different sections
getAudioFileUpdate() async {
  // Get the application support directory path
  String directory = (await getApplicationSupportDirectory()).path;

  // List to store directories containing audio files
  List<Directory> listOfFileDirectories = [];

  // List to store audio file names from the local directories
  List<String> fileNames = [];

  // Extract audio file names from the server and store them in listFileNameFromServer
  for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
    listFileNameFromServer.add(
      sectionDetail[audioTracks]['DS_AUD_PATH'].split("/").last.split(".mp3").first,
    );
  }

  // Loop to create or update audio files for different sections
  for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
    // Define the path for the audio file
    File audioFile = File(
      "$directory/DigiVidya/Section_${audioTracks + 1}/AudioFile/${listFileNameFromServer[audioTracks]}.mp3",
    );

    // Check if the audio file does not exist
    if (!audioFile.existsSync()) {
      // Create the audio file and its directory if it doesn't exist
      audioFile.createSync(recursive: true);

      // Read and decode the audio content, then write it to the audio file
      audioFile.writeAsBytes(
        List<int>.from(Base64Decoder().convert(cardsAudio['${sectionIds[audioTracks]}'])),
        flush: true,
      );

      // Store the path of the audio file for creating the playlist and playing it
      cardsAudioFilePath.add(audioFile.path);
    } else {
      // List all directories within the DigiVidya directory
      Directory("$directory/DigiVidya/").listSync(followLinks: true).forEach((element) {
        if (element is Directory) {
          listOfFileDirectories.add(element);
        }
      });

      // Iterate through directories to get audio file names and check for updates
      for (Directory dir in listOfFileDirectories) {
        try {
          Directory("${dir.path}/AudioFile/").listSync().forEach((element) {
            fileNames.add(path.basename(element.path).toString().split(".").first);
          });
        } catch (e) {
          print("Error occurred while processing list of files from directories");
        }
      }

      // Check for updates in audio files by comparing with server file names
      if (listFileNameFromServer[audioTracks] != fileNames[audioTracks]) {
        // Rename and update the audio file if there is a new version from the server
        audioFile.rename(
          "$directory/DigiVidya/Section_${audioTracks + 1}/AudioFile/${listFileNameFromServer[audioTracks]}.mp3",
        );

        audioFile.writeAsBytes(
          List<int>.from(Base64Decoder().convert(cardsAudio['${sectionIds[audioTracks]}'])),
          flush: true,
        );

        // Store the path of the updated audio file
        cardsAudioFilePath.add(audioFile.path);
      } else {
        // Store the path of the existing audio file
        cardsAudioFilePath.add(audioFile.path);
      }
    }
  }
}


// Method to initialize temporary boolean values and progress indicators for each section
_generateTempBoolValue() {
  // Loop through the number of sections
  for (int sectionItem = 0; sectionItem < sectionCount; sectionItem++) {
    // Add an initial progress value of 0.0 for each section
    _sectionProgress.add(0.0);

    // Add a boolean value of false indicating that no section is completed initially
    _getCompletedSectionBoolValue.add(false);
  }

  // Print the initialized progress and completion status for debugging purposes
  print(
      "%%%%%%%%%%%%%%%%%%%%%%%%%%%% ${_sectionProgress} , ${_getCompletedSectionBoolValue} %%%%%%%%%%%%%%%%%%%%%%%");
}


// Method to fetch and update the details of completed sections for the user
_getSectionCompletedDetails() async {
  // Get the application support directory path
  String dirpath = (await getApplicationSupportDirectory()).path;
  // Define the path to the JSON file that stores user data
  File jsonFile = File("$dirpath/appInfo.json");

  // Define the URL for the API that fetches the completed sections
  String url = "https://digividya.in/DigiVidyaAPI/api/completedSections";

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    try {
      // Read and decode the JSON data from the file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      // Extract the user ID from the JSON data
      var userId = jsonData['User_Id'];

      // Create a map with the user ID to send with the API request
      var userData = {
        "user_id": userId.toString(),
      };

      // Make a POST request to the API with the user data
      var response = await http.post(Uri.parse(url), body: userData);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode the JSON response from the API
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        // Check if the JSON response is not empty
        if (jsonResponse.isNotEmpty) {
          // Extract the completed section IDs and their counts from the response
          Map<String, dynamic> CompletedSectionId =
              jsonResponse['count_of_IDs'];

          print(
              "%%%%%%%%%%%%%%%% Section Completed count with IDS : $CompletedSectionId %%%%%%%%%%%%%%%%%%%%%%%%%%");

          // Update the boolean values indicating which sections are completed
          sectionIds.forEach((element) {
            int indexOfItem = sectionIds.indexOf(element);
            int pointer = 0;
            if (CompletedSectionId.containsKey(element.toString()) &&
                (CompletedSectionId[element.toString()] ==
                    SectionSTopicCount[pointer])) {
              _getCompletedSectionBoolValue[indexOfItem] = true;
              pointer++;
            }
          });

          print(
              "%%%%%%%%%%%%%%%% Section Completed count with IDS : $CompletedSectionId %%%%%%%%%%%%%%%%%%%%%%%%%%");

          // Update the progress values for each section
          for (int itemProgress = 0; itemProgress < sectionCount; itemProgress++) {
            _sectionProgress[itemProgress] =
                (CompletedSectionId[sectionIds[itemProgress].toString()] /
                    SectionSTopicCount[itemProgress]);
          }

          // Indicate that the progress details have been fetched
          progressOfSection.value = true;
        }
      }
    } on http.ClientException catch (e) {
      // Print any client exception messages encountered during the API call
      print(e.message);
    }
  }
}


// Method to check if there is an incoming app link available and handle it
void _checkApplinkAvail() async {
  // Create an instance of the Applink class
  Applink _applink = Applink();
  // Handle the incoming app link
  await _applink.ApplinkHandling();

  // Check if an app link is available
  if (_applink.ApplinkAvail()) {
    // Stop audio playback if any
    player.stopAudio();
    // Print a message indicating that an app link is available
    print("%%%%%%%%%%%%%%%%%%%%% Applink Available %%%%%%%%%%%%%%%%%%");

    // Check the path of the app link
    if (_applink.getPath() == "/") {
      // If the path is the root ("/"), navigate to the section page
      print("%%%%%%%%%%%% App Link of Section Page %%%%%%%%%%%%%%%%%%%%%");
      Navigator.of(context).pushReplacementNamed(_applink.getPath(),
          arguments: _applink.getarguments());
    }
    if (_applink.getPath() == "/topicpage.php") {
      // If the path is "/topicpage.php", navigate to the topic page
      print("%%%%%%%%%%%% App Link of Topic Page %%%%%%%%%%%%%%%%%%%%%");
      Navigator.of(context).pushReplacementNamed("/TopicPage",
          arguments: _applink.getarguments());
    }
    if (_applink.getPath() == "/subtopicpage.php") {
      // If the path is "/subtopicpage.php", navigate to the subtopic page
      print("%%%%%%%%%%%% App Link of SubTopic Page %%%%%%%%%%%%%%%%%%%%%");
      Navigator.of(context).pushReplacementNamed("/subTopicPage",
          arguments: _applink.getarguments());
    }
  }
}


// Method to share a section with a given URL and file path
void shareSection(String url, String path) async {
  // Share the file located at the specified path along with the URL
  await Share.shareFiles([path], text: url).then((_) {
    // After sharing, delete the file from the device
    File(path).deleteSync(recursive: true);
  });
}

}
