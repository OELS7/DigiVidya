import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:digividya/widgets/InternalserverError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/Lock_Cards.dart';
import 'package:digividya/widgets/commingSoonAlertBox.dart';
import 'package:digividya/widgets/DownloadDialogBox.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class supTopicPage extends StatefulWidget {
  const supTopicPage({super.key});

  @override
  State<supTopicPage> createState() => _supTopicPageState();
}

class _supTopicPageState extends State<supTopicPage>
    with WidgetsBindingObserver {
// FixedExtentScrollController for controlling the scroll position
  final FixedExtentScrollController _fixedExtentScrollController =
      FixedExtentScrollController();

// ValueNotifier for notifying listeners when the value changes
  final ValueNotifier<double> _valueNotifier = ValueNotifier<double>(0.0);

// Connectivity object for checking network connectivity
  Connectivity _connectivity = Connectivity();

// ValueNotifier to indicate if data has been fetched
  ValueNotifier<dynamic> dataFatched = ValueNotifier(false);

// ValueNotifier to indicate if completed list of boolean values
  ValueNotifier<bool> completedListOfBool = ValueNotifier<bool>(false);

// ConcatenatingAudioSource for playlist
  late ConcatenatingAudioSource playList;

// Background audio player
  late bgAudioPlayer player;

// Maps for subtopic cards image, audio, likes, views, and URLs
  Map<String, dynamic> subTopicCardsImage = {};
  Map<String, dynamic> subTopicCardsAudio = {};
  Map<String, dynamic> subTopicsLikes = {};
  Map<String, dynamic> subTopicView = {};
  Map<String, dynamic> urls = {};

// Lists for subtopic details, IDs, audio file names, byte data, and more
  List<dynamic> subTopicDetails = [];
  List<dynamic> subTopicIds = [];
  List<String> audioFileName = [];
  List<dynamic> deviceAudioFileName = [];
  List<dynamic> demolist = [];
  List<dynamic> contentUrls = [];
  List<dynamic> imageByteData = [];
  List<String> subTopicAudioFilePath = [];
  List<String> FileName = [];
  List<String> subTopicTitle = [];
  List<String> subTopicViewsCount = [];
  List<String> subTopicLikesCount = [];
  List<String> UpdatedFileName = [];
  List<String> AssignmentFileName = [];
  List<bool> add_InVisibleList = [];

// Variables for section, topic, subtopic IDs, counts, likes, views, and more
  int sectionId = 0,
      topicId = 0,
      subTopicId = 0,
      subTopicCount = 0,
      Likes = 0,
      Views = 0,
      topicCount = 0;
  String subTopicCardImg = "", audioName = "", UserName = "";

// Variables for section, topic, and part numbers
  int sectionNumber = 0, topicNumber = 0, partNumber = 0;

// Test variable initialized to 0.0
  double test = 0.0;

// Context variables for download dialog box and page context
  var _downloadDialogBoxContext;
  var pageContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check network connectivity
    _checkConnectivity();

    // Add listener to fixed extent scroll controller
    _fixedExtentScrollController.addListener(() => onScroll());
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments passed to this route
    final argument =
        (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;

    // Assign values from arguments to corresponding variables
    sectionId = (argument['section'] is String)
        ? int.parse(argument['section'].toString())
        : argument['section'];
    topicId = (argument['topic'] is String)
        ? int.parse(argument['topic'].toString())
        : argument['topic'];
    subTopicCount = (argument['subTopicCount'] is String)
        ? int.parse(argument['subTopicCount'].toString())
        : argument['subTopicCount'];
    topicCount = (argument['topicCount'] is String)
        ? int.parse(argument['topicCount'].toString())
        : argument['topicCount'];

    // Check and add values to add_InVisibleList if it's empty
    (add_InVisibleList.isEmpty) ? addValueToadd_InVisibleList() : () {};

    // Set pageContext to the current context
    pageContext = context;

    // getFileNames();

    // Return Scaffold with app bar and body
    return Scaffold(
      appBar: AppBar(
        // Custom leading widget for app bar
        leading: Row(
          children: [
            // Back button leading to TopicPage
            BackButton(
              onPressed: () {
                // Delay and stop audio before navigating back
                Future.delayed(
                  Duration(milliseconds: 300),
                  () {
                    player.stopAudio();
                    Navigator.pushReplacementNamed(context, "/TopicPage",
                        arguments: {
                          "section": sectionId,
                          "topic_count": topicCount
                        });
                    return false;
                  },
                );
              },
            ),
            Text("Back") // Text beside back button
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width *
            1, // Leading width set to full width of screen
      ),
      // Body of Scaffold wrapped in SafeArea
      body: SafeArea(
        child: ValueListenableBuilder(
          // Builder for listening to changes in dataFetched value
          valueListenable: dataFatched,
          builder: (context, value, child) {
            if (value is bool) {
              // Check if value is boolean
              if (value) {
                // If value is true
                return ValueListenableBuilder(
                  // Builder for listening to changes in completedListOfBool value
                  valueListenable: completedListOfBool,
                  builder: (context, value, child) {
                    if (value is bool) {
                      // Check if value is boolean
                      if (value) {
                        // If value is true, return subTopicList
                        return subTopicList(subTopicCount);
                      } else {
                        // If value is false, return subTopicList
                        return subTopicList(subTopicCount);
                      }
                    } else {
                      // If value is not boolean, return subTopicList
                      return subTopicList(subTopicCount);
                    }
                  },
                );
              } else {
                // If value is false, show loading indicator
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
                              decoration: TextDecoration.none),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              // If value is not boolean, show CircularProgressIndicator
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
    );
  }

// Function to add false values to add_InVisibleList
  addValueToadd_InVisibleList() {
    // Loop to add false values to add_InVisibleList
    for (int addInVisibleList = 0;
        addInVisibleList < subTopicCount;
        addInVisibleList++) {
      add_InVisibleList.add(false);
    }
    // Print statement to indicate the bool value of the completed list
    print(
        "%%%%%%%%%%%%%%%%This is bool value of completd list $add_InVisibleList %%%%%%%%%%%%%%%%%%%%%%");
  }

  // Image.asset(
  //   "assets/images/completed-tick-icon 22-01.png",
  //   width: MediaQuery.of(context).size.width * 0.5,
  // )

  subTopicList(int subTopicCount) {
    // Initialize an empty list to hold the subtopic cards.
    List<Widget> subTopicCards = [];

    // Loop through each subtopic and create a card for it.
    for (int i = 0; i < subTopicCount; i++) {
      subTopicCards.add(GestureDetector(
        onTap: () async {
          // Stop the audio if there are content URLs.
          (contentUrls.length != 0) ? player.stopAudio() : {};

          // If the user is a guest and the subtopic is not the first one, show a lock dialog.
          (UserName == "Guest" && i != 0)
              ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var LockCardContext = context;
                    return lockcard(LockCardDialogContext: LockCardContext);
                  },
                )
              // If there are content URLs, play the content.
              : (contentUrls.length != 0)
                  ?
                      _PlayContent(contentList: contentUrls, FileName: FileName)
                    

                  // Otherwise, show a "coming soon" dialog.
                  : showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        var commingSoonContext = context;
                        return commingSoonAlertbox(
                            comingSoonDialogContext: commingSoonContext);
                      },
                    );
        },
        child: Card(
          // color: Colors.blue,
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          shadowColor: Colors.black,
          elevation: 25,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(58),
          ),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(58),
                    image: DecorationImage(
                        image: MemoryImage(imageByteData[i]),
                        fit: BoxFit.fill)),
              ),
              (UserName != "Guest")
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.2,
                      //left: MediaQuery.of(context).size.width * 0.19,
                      right: MediaQuery.of(context).size.width * 0.232,
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Visibility(
                          visible: add_InVisibleList[i],
                          child: LottieBuilder.asset(
                            "assets/Animation/9kASTq22vM.json",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            repeat: false,
                          )))
                  : (UserName == "Guest" && i == 0)
                      ? Positioned(
                          top: MediaQuery.of(context).size.height * 0.2,
                          //left: MediaQuery.of(context).size.width * 0.19,
                          right: MediaQuery.of(context).size.width * 0.232,
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Visibility(
                              visible: add_InVisibleList[i],
                              child: LottieBuilder.asset(
                                "assets/Animation/9kASTq22vM.json",
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                repeat: false,
                              )))
                      : SizedBox(),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.43,
                  left: 0.0,
                  right: 0.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            subTopicTitle[i],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            softWrap: false,
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    'assets/app_icons/heart.png',
                                    height: 30,
                                    width: 50,
                                  ),
                                  Text("${subTopicLikesCount[i]}")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    'assets/app_icons/ViewIcon.webp',
                                    height: 30,
                                    width: 50,
                                  ),
                                  Text("${subTopicViewsCount[i]}")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.015,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.005),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(42, 59, 142, 1),
                                    Color.fromRGBO(4, 225, 203, 1)
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: const Center(
                            child: Text(
                              "START",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              (UserName == "Guest" && i != 0)
                  ? Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/LockCardImage.webp"),
                              fit: BoxFit.fill)),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ));
    }

    return ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        magnification: 1.0,
        itemExtent: 530,
        controller: _fixedExtentScrollController,
        children: subTopicCards);
  }

  _downloadLession(
      {required String fileUrl, required String fileSaveLocatio}) async {
    int downloaded = 0; // Initialize downloaded data length to zero
    List<List<int>> chunks = []; // Initialize a list to hold data chunks

    try {
      // Define the URL for the file download
      final url = Uri.parse(
          "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl");

      // Create a new HTTP GET request
      var request = new http.Request('GET', url);

      // Send the HTTP request
      var response = http.Client().send(request);

      // Listen to the response stream
      response.asStream().listen((http.StreamedResponse r) {
        r.stream.listen((List<int> chunk) {
          // Display percentage of download completion
          debugPrint(
              'downloadPercentage: ${downloaded / r.contentLength! * 100}');

          // Add the received chunk to the list of chunks
          chunks.add(chunk);

          // Update the total downloaded data length
          downloaded += chunk.length;

          // Update the value notifier with the download progress
          _valueNotifier.value = (downloaded / r.contentLength!);
        }, onDone: () async {
          // Display percentage of download completion
          debugPrint(
              'downloadPercentage: ${downloaded / r.contentLength! * 100}');

          // Update the value notifier with the final download progress
          _valueNotifier.value = (downloaded / r.contentLength!);

          // Create a new file at the specified save location
          File file = new File(fileSaveLocatio);

          // Create a byte array to hold the complete file data
          final Uint8List bytes = Uint8List(r.contentLength!);
          int offset = 0; // Initialize offset to zero

          // Combine all chunks into the byte array
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }

          // Check if the file already exists
          if (!await file.exists()) {
            // If file doesn't exist, create it and write the byte array to it
            await file
                .create(recursive: true)
                .then(
                    (value) => file.writeAsBytes(bytes, mode: FileMode.append))
                .then((_) {
              _playSpecificFile(
                  ContentFileAddress: file.path); // Play the downloaded file
            });
          } else {
            // If file exists, delete it and create a new one
            await file.delete(recursive: true).then((value) {
              file
                  .create(recursive: true)
                  .then(
                      (value) => file.writeAsBytes(bytes, mode: FileMode.write))
                  .then((value) {
                _playSpecificFile(
                    ContentFileAddress: file.path); // Play the downloaded file
              });
            });
          }
        });
      });
    } on http.ClientException catch (e) {
      // Handle HTTP client exceptions
      print(e);

      // Reset the value notifier
      setState(() {
        _valueNotifier.value = 0.0;
      });

      // Close the download dialog box
      Navigator.of(_downloadDialogBoxContext).pop();

      // Show an error dialog for low internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Low internet connection. Please check your internet.",
          );
        },
      );
    }
  }

  getSubTopicDetails() async {
    // Get the path to the application support directory
    String dirPath = (await getApplicationSupportDirectory()).path;
    // Create a File object for the appInfo.json file
    File jsonFile = File("$dirPath/appInfo.json");

    // Define the URL for the API request to fetch top subtopics
    String url = "https://digividya.in/DigiVidyaAPI/api/fetchTopSubtopics";

    // Create a map with the topic_id to send with the POST request
    var userData = {"topic_id": topicId.toString()};

    // Check if the JSON file exists
    if (jsonFile.existsSync()) {
      // Read and decode the JSON data from the file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      // Get the user name from the JSON data
      UserName = jsonData['UserName'].toString();
      // Send a POST request to the API with the user data
      var response = await http.post(Uri.parse(url), body: userData);

      try {
        // Check if the response status code is 200 (OK)
        if (response.statusCode == 200) {
          // Decode the JSON response body
          Map<String, dynamic> jsonResponse =
              jsonDecode(response.body.toString().replaceAll("\n", " "));

          // Check if the JSON response is not empty
          if (jsonResponse.isNotEmpty) {
            setState(() {
              // Update the subtopic details with the data from the response
              subTopicDetails = jsonResponse['sub_topics'];
              subTopicIds = jsonResponse['subtopic_ids'];
              subTopicCardsImage = jsonResponse['subtopics_img'];
              subTopicCardsAudio = jsonResponse['subtopics_aud'];
              urls = jsonResponse['all_list'];
              contentUrls = urls['${subTopicIds[0]}'];

              // Extract file names from the content URLs
              contentUrls.forEach((element) {
                FileName.add(element.toString().split("/").last.trim());
              });

              print(
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< $FileName >>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

              // Set the initial subtopic ID and image
              subTopicId = subTopicIds[0];
              subTopicCardImg = subTopicCardsImage['${subTopicIds[0]}'];

              // Decode and add images from Base64 strings
              subTopicCardsImage.forEach((key, value) {
                imageByteData.add(Base64Decoder().convert(value));
              });

              // Add subtopic titles to the list
              subTopicDetails.forEach((element) {
                subTopicTitle.add(element['DST_NAME']);
              });

              // Add likes and views count to the lists
              subTopicDetails.forEach((element) {
                subTopicLikesCount.add(element['subtopics_likes'].toString());
                subTopicViewsCount.add(element['subtopics_views'].toString());
              });
            });
            // Mark the data as fetched and complete the subtopic
            _completedSubTopic();
            dataFatched.value = true;
          }
        } else {
          // Show an error dialog for internal server error
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
                  Future.delayed(Duration(milliseconds: 50), () {
                    getSubTopicDetails();
                  });
                  Navigator.of(InternalserverErrorContext).pop(false);
                },
                ButtonText: "reload",
              );
            },
          );
        }
      } on http.ClientException catch (e) {
        // Check the connectivity status
        final _checkConnectivity = await _connectivity.checkConnectivity();
        if (_checkConnectivity == ConnectivityResult.none) {
          // Show an error dialog for no internet connection
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              var InternalserverErrorContext = context;
              return InternalserverError(
                InternalserverErrorContext: InternalserverErrorContext,
                ErrorTitle: "No Internet",
                Description:
                    "Maybe you don't have internet connection. Please check and try again.",
                retryButton: () {
                  Future.delayed(Duration(milliseconds: 50), () {
                    getSubTopicDetails();
                  });
                  Navigator.of(InternalserverErrorContext).pop(false);
                },
                ButtonText: "reload",
              );
            },
          );
        } else {
          // Show an error dialog for poor internet connection
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
                  Future.delayed(Duration(milliseconds: 50), () {
                    getSubTopicDetails();
                  });
                  Navigator.of(InternalserverErrorContext).pop(false);
                },
                ButtonText: "try again",
              );
            },
          );
        }

        // Print the error message
        print(e.message.toString());
      }
    }
    return;
  }

// Define the onScroll function
  onScroll() {
    // Check if the user is scrolling in the reverse direction
    if (_fixedExtentScrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Schedule a callback after the current frame has been rendered
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Update the state of the widget
        setState(() {
          // Update the subTopicId with the selected item index
          subTopicId = subTopicIds[_fixedExtentScrollController.selectedItem];

          // Update the subTopicCardImg with the selected item's image
          subTopicCardImg = subTopicCardsImage[
              '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          // Update the contentUrls with the selected item's URLs
          contentUrls = urls[
              subTopicIds[_fixedExtentScrollController.selectedItem]
                  .toString()];

          // Clear the FileName list
          FileName.clear();
          // Extract and add file names from the content URLs
          contentUrls.forEach((element) {
            FileName.add(element.toString().split("/").last.trim());
          });

          // Play the next track using the player
          player.playNextTrack(
              nextTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
    } else {
      // Schedule a callback after the current frame has been rendered
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Update the state of the widget
        setState(() {
          // Update the subTopicId with the selected item index
          subTopicId = subTopicIds[_fixedExtentScrollController.selectedItem];

          // Update the subTopicCardImg with the selected item's image
          subTopicCardImg = subTopicCardsImage[
              '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          // Update the contentUrls with the selected item's URLs
          contentUrls = urls[
              subTopicIds[_fixedExtentScrollController.selectedItem]
                  .toString()];

          // Clear the FileName list
          FileName.clear();
          // Extract and add file names from the content URLs
          contentUrls.forEach((element) {
            FileName.add(element.toString().split("/").last.trim());
          });

          // Play the previous track using the player
          player.playPreviousTrack(
              previousTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
    }
  }

// Define the _setSubTopicViewCount function
  void _setSubTopicViewCount({required String directoryPath}) async {
    // File object of json file
    File jsonFile = File("$directoryPath/appInfo.json");

    // Initialize userId and subtopicId variables
    var userid = 0, subtopic_Id = 0;

    // Check if the json file exists
    if (jsonFile.existsSync()) {
      // Read and decode the json file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());

      // Update the state with userId and subtopicId from json data
      setState(() {
        userid = jsonData['User_Id'];
        subtopic_Id = jsonData['subTopic_Id'];
      });

      // Create a map with userId and subtopicId as strings
      var userData = {
        "user_id": userid.toString(),
        "subtopic_id": subtopic_Id.toString()
      };

      // Define the URL for the API endpoint
      // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/storeViewsForSubtopic";
      String url =
          "https://digividya.in/DigiVidyaAPI/api/storeViewsForSubtopic";

      // Make a POST request to the API with the user data
      var response = await http.post(Uri.parse(url), body: userData);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        // Check if the jsonResponse is not empty
        if (jsonResponse.isNotEmpty) {
          // Do nothing if jsonResponse is not empty (you may add any specific handling here)
        }
      } else {
        // Show a dialog indicating a low internet connection
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // Save the current context in a variable
            var internetErrorContext = context;
            // Return the InternetErrorDialog with a specific message
            return InternetErrorDialog(
              internetErrorDialogContext: internetErrorContext,
              message: "Low internet connection. Please check your internet.",
            );
          },
        );
      }
    }
  }

  // Define the _onBackButtonPressed function
  Future<bool> _onBackButtonPressed() {
    // Return a Future that completes after a delay
    return Future.delayed(
      // Specify the duration of the delay (300 milliseconds)
      Duration(milliseconds: 300),
      // Define the callback function to be executed after the delay
      () {
        // Stop the audio playback
        player.stopAudio();
        // Navigate to the TopicPage and replace the current route
        Navigator.pushReplacementNamed(
          context, // The current BuildContext
          "/TopicPage", // The name of the route to push
          arguments: {
            "section": sectionId, // Pass the sectionId as an argument
            "topic_count": topicCount // Pass the topicCount as an argument
          },
        );
        // Return false to indicate that the back button press was handled
        return false;
      },
    );
  }

// Define the _checkConnectivity function
  void _checkConnectivity() async {
    // Check the connectivity status asynchronously
    final _checkConnectivity = await _connectivity.checkConnectivity();

    // If there is no internet connection
    if (_checkConnectivity == ConnectivityResult.none) {
      // Show a dialog indicating low internet connection
      showDialog(
        context: context, // The current BuildContext
        barrierDismissible:
            false, // Prevent the dialog from being dismissed by tapping outside
        builder: (context) {
          // Builder function to create the dialog
          var internetErrorContext = context; // Save the current context
          return InternetErrorDialog(
            internetErrorDialogContext:
                internetErrorContext, // Pass the context to the dialog
            message:
                "Low internet connection . Please check your internet.", // Message to display
          );
        },
      );
    } else {
      // If there is internet connection, fetch sub-topic details
      getSubTopicDetails().then((_) {
        // After fetching sub-topic details, get updated content file names
        _getUpdatedContentFileName().then((_) {
          // Prepare the playlist for the audio player
          playList = ConcatenatingAudioSource(
            useLazyPreparation: true, // Enable lazy preparation
            children: List.generate(
                subTopicCount, // Generate audio sources for each sub-topic
                (index) => AudioSource.file(subTopicAudioFilePath[
                    index])), // Create an AudioSource for each file
          );
          // Initialize the background audio player with the playlist
          player = bgAudioPlayer(concatenatingAudioSource: playList);
          // Initialize the audio player
          player.initAudioPlayer();
        });
      });
    }
  }

// Define the _PlayContent function
  _PlayContent(
      {required List<dynamic> contentList,
      required List<String> FileName}) async {
    // Get the application support directory path
    String dir = (await getApplicationSupportDirectory()).path;

    // Check the file extension of the first item in the content list
    switch (contentList[0].toString().split("/").last.split(".").last) {
      case "mp4":
        // Print message indicating MP4 content
        print(
            "<<<<<<<<<<<<<<<< This Url Contains Mp4 Extension >>>>>>>>>>>>>>>>>>>>>");

        // Create a File object for the video file
        File videoFile = File(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Video/${FileName[0]}");

        // Check if the video file exists
        if (videoFile.existsSync()) {
          // If the video file exists, navigate to the video page
          Navigator.pushReplacementNamed(context, '/vidoePage', arguments: {
            "filePath":
                "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Video/${FileName[0]}",
            "minutes": 0,
            "seconds": 0,
            "section": sectionId,
            "topic": topicId,
            "topicCount": topicCount,
            "subTopic": subTopicId,
            "subTopicCount": subTopicCount,
            "contentUrls": contentUrls,
            "itemPointer": 0,
            "FileName": FileName
          });
        } else {
          // If the video file does not exist, update the JSON file and download the video
          String dirPath = (await getApplicationSupportDirectory()).path;
          File JsonFile = File("$dirPath/appInfo.json");
          var jsonData = jsonDecode(JsonFile.readAsStringSync());
          jsonData['subTopic_Id'] = subTopicId;
          JsonFile.writeAsStringSync(jsonEncode(jsonData));

          // Call the _downloadLession function to download the video
          _downloadLession(
              fileUrl: contentList[0], fileSaveLocatio: videoFile.path);

          // Show a dialog indicating the download is in progress
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              _downloadDialogBoxContext = context;
              return downloadDialogBox(
                dialogTitle: "Downloading..",
                progress: _valueNotifier,
              );
            },
          );
        }
        break;

      case "zip":
        // Print message indicating ZIP content
        // print("<<<<<<<<<<<<<<<< This Url Contains Zip Extension >>>>>>>>>>>>>>>>>>>>>");

        // Create a Directory object for the assessment directory
        Directory AssessmrntDirectory = Directory(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/");

        // Check if the assessment directory exists
        if (AssessmrntDirectory.existsSync()) {
          // Create a File object for the assessment HTML file
          File assessmentHtmlFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");

          // Check if the assessment HTML file exists
          if (assessmentHtmlFile.existsSync()) {
            // If the assessment HTML file exists, navigate to the assessment page
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath": assessmentHtmlFile.path.toString(),
                  "section": sectionNumber,
                  "topic": topicNumber,
                  "topicCount": topicCount,
                  "subTopic": subTopicId,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": 0,
                  "FileName": FileName
                });
          } else {
            // If the assessment HTML file does not exist, navigate to the assessment page with the other file path
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath":
                      "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story.html",
                  "section": sectionNumber,
                  "topic": topicNumber,
                  "topicCount": topicCount,
                  "subTopic": subTopicId,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": 0,
                  "FileName": FileName
                });
          }
        } else {
          // Create a File object for the assessment ZIP file
          File AssessmentZipFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0]}");

          // Check if the assessment ZIP file does not exist
          if (!AssessmentZipFile.existsSync()) {
            // Update the JSON file and download the ZIP file
            String dirPath = (await getApplicationSupportDirectory()).path;
            File JsonFile = File("$dirPath/appInfo.json");
            var jsonData = jsonDecode(JsonFile.readAsStringSync());
            jsonData['subTopic_Id'] = subTopicId;
            JsonFile.writeAsStringSync(jsonEncode(jsonData));

            // Call the _downloadLession function to download the ZIP file
            _downloadLession(
                fileUrl: contentList[0],
                fileSaveLocatio: AssessmentZipFile.path);

            // Show a dialog indicating the download is in progress
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                _downloadDialogBoxContext = context;
                return downloadDialogBox(
                  dialogTitle: "Downloading..",
                  progress: _valueNotifier,
                );
              },
            );
          } else {
            // Extract the ZIP file to the destination directory
            ZipFile.extractToDirectory(
              zipFile: AssessmentZipFile,
              destinationDir: Directory(
                  "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/"),
              onExtracting: (zipEntry, progress) {
                print(zipEntry.name); // Print the name of the zip entry
                print(progress.round() * 100); // Print the extraction progress
                return ZipFileOperation
                    .includeItem; // Include the item in the extraction
              },
            ).then((_) {
              // After extraction, check if the assessment HTML file exists
              File assessmentHtmlFile = File(
                  "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");

              // Navigate to the appropriate assessment page based on the existence of the HTML file
              if (assessmentHtmlFile.existsSync()) {
                Navigator.pushReplacementNamed(context, '/assessmentPage',
                    arguments: {
                      "htmlFilePath": assessmentHtmlFile.path.toString(),
                      "section": sectionNumber,
                      "topic": topicNumber,
                      "topicCount": topicCount,
                      "subTopic": subTopicId,
                      "subTopicCount": subTopicCount,
                      "contentUrls": contentUrls,
                      "itemPointer": 0,
                      "FileName": FileName
                    });
              } else {
                Navigator.pushReplacementNamed(context, '/assessmentPage',
                    arguments: {
                      "htmlFilePath":
                          "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story.html",
                      "section": sectionNumber,
                      "topic": topicNumber,
                      "topicCount": topicCount,
                      "subTopic": subTopicId,
                      "subTopicCount": subTopicCount,
                      "contentUrls": contentUrls,
                      "itemPointer": 0,
                      "FileName": FileName
                    });
              }
            });
          }
        }
        break;

      default:
      // Handle other file types if necessary
    }
  }

// Define the _playSpecificFile function
  void _playSpecificFile({required String ContentFileAddress}) async {
    // Get the application support directory path
    String dir = (await getApplicationSupportDirectory()).path;

    // Check if the content file has an MP4 extension
    if (ContentFileAddress.split(".").last == "mp4") {
      // Set the sub-topic view count
      _setSubTopicViewCount(directoryPath: dir);

      // Update the state
      setState(() {
        // Delay the navigation to the video page
        Future.delayed(
          const Duration(milliseconds: 900),
          () {
            // Navigate to the video page with the specified arguments
            Navigator.pushReplacementNamed(context, '/vidoePage', arguments: {
              "filePath": ContentFileAddress,
              "minutes": 0,
              "seconds": 0,
              "section": sectionId,
              "topic": topicId,
              "topicCount": topicCount,
              "subTopic": subTopicId,
              "subTopicCount": subTopicCount,
              "contentUrls": contentUrls,
              "itemPointer": 0,
              "FileName": FileName
            });
          },
        );
        // Close the download dialog box
        Navigator.of(_downloadDialogBoxContext).pop();
      });
    } else {
      // Playing Assessment File
      setState(() {
        // Set the sub-topic view count
        _setSubTopicViewCount(directoryPath: dir);

        // Extract the ZIP file to the destination directory
        ZipFile.extractToDirectory(
                zipFile: File(ContentFileAddress),
                destinationDir: Directory(
                    "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/"))
            .then((_) {
          // Create a File object for the assessment HTML file
          File assessmentHtmlFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");

          // Check if the assessment HTML file exists
          if (assessmentHtmlFile.existsSync()) {
            // Navigate to the assessment page with the specified arguments
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath": assessmentHtmlFile.path.toString(),
                  "section": sectionNumber,
                  "topic": topicNumber,
                  "topicCount": topicCount,
                  "subTopic": subTopicId,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": 0,
                  "FileName": FileName
                });
          } else {
            // Navigate to the assessment page with an alternative file path
            Navigator.pushReplacementNamed(context, '/assessmentPage',
                arguments: {
                  "htmlFilePath":
                      "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story.html",
                  "section": sectionNumber,
                  "topic": topicNumber,
                  "topicCount": topicCount,
                  "subTopic": subTopicId,
                  "subTopicCount": subTopicCount,
                  "contentUrls": contentUrls,
                  "itemPointer": 0,
                  "FileName": FileName
                });
          }
        });
        // Print the content file address
        // print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $ContentFileAddress &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

        // Close the download dialog box
        Navigator.of(_downloadDialogBoxContext).pop();
      });
    }
  }

// Override the didChangeAppLifecycleState method
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Call the superclass implementation of didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    // Check if the app lifecycle state is paused
    if (state == AppLifecycleState.paused) {
      // Stop the audio player when the app is paused
      player.stopAudio();
    }

    // Check if the app lifecycle state is detached
    if (state == AppLifecycleState.detached) {
      // Stop the audio player when the app is detached
      player.stopAudio();
    }
  }

// Define an asynchronous method to get updated content file names
  _getUpdatedContentFileName() async {
    // Get the application support directory path
    String directory = (await getApplicationSupportDirectory()).path;
    // Initialize a list to store directories of audio files
    List<Directory> listofFileDirectory = [];
    // Initialize a list to store file names
    List<String> fileName = [];

    // Loop through subTopicCount to get audio file names
    for (var audioTracks = 0; audioTracks < subTopicCount; audioTracks++) {
      // Add the audio file name to the audioFileName list
      audioFileName.add(subTopicDetails[audioTracks]['DST_AUD_PATH']
          .split("/")
          .last
          .split(".mp3")
          .first);
    }

    // Loop through subTopicCount to process audio files
    for (var audioTracks = 0; audioTracks < subTopicCount; audioTracks++) {
      // Create a File object for the subTopic audio file
      File sTopicAudioFile = File(
          "$directory/DigiVidya/Section_$sectionId/AudioFile/Topic_$topicId/SubTopic_${audioTracks + 1}/${audioFileName[audioTracks]}.mp3");

      // Check if the audio file does not exist
      if (!sTopicAudioFile.existsSync()) {
        // Create the audio file
        sTopicAudioFile.createSync(recursive: true);

        // Write the audio data to the file
        await sTopicAudioFile.writeAsBytes(
            List<int>.from(Base64Decoder()
                .convert(subTopicCardsAudio['${subTopicIds[audioTracks]}'])),
            flush: true);
        // Add the file path to the subTopicAudioFilePath list
        subTopicAudioFilePath.add(sTopicAudioFile.path);
      } else {
        // List the directories in the specified path
        Directory(
                "$directory/DigiVidya/Section_$sectionId/AudioFile/Topic_$topicId/")
            .listSync(followLinks: true)
            .forEach((element) {
          if (element is Directory) {
            // Add the directory to the listofFileDirectory list
            listofFileDirectory.add(element);
          }
        });

        // Print the list of directories (for debugging purposes)
        // print("%%%%%%%%%%%%%%%%%%%%% $listofFileDirectory %%%%%%%%%%%%%%%");

        // Loop through the list of directories
        for (Directory directory in listofFileDirectory) {
          try {
            // List the files in the directory
            Directory("${directory.path}/").listSync().forEach((element) {
              // Print the file path (for debugging purposes)
              // print("%%%%%%%%%%%%%%%%%%%%% $element %%%%%%%%%%%%%%%");

              // Add the file name to the fileName list
              fileName
                  .add(path.basename(element.path).toString().split(".").first);
            });
          } catch (e) {
            // Handle the exception (if any)
          }
        }

        // Check if the audio file name does not match the file name
        if (audioFileName[audioTracks] != fileName[audioTracks]) {
          // Rename the audio file
          sTopicAudioFile.renameSync(
              "$directory/DigiVidya/Section_$sectionId/AudioFile/Topic_$topicId/SubTopic_${audioTracks + 1}/${audioFileName[audioTracks]}.mp3");

          // Write the audio data to the file
          await sTopicAudioFile.writeAsBytes(
              List<int>.from(Base64Decoder()
                  .convert(subTopicCardsAudio['${subTopicIds[audioTracks]}'])),
              flush: true);
          // Add the file path to the subTopicAudioFilePath list
          subTopicAudioFilePath.add(sTopicAudioFile.path);
        } else {
          // Add the file path to the subTopicAudioFilePath list
          subTopicAudioFilePath.add(sTopicAudioFile.path);
        }
      }
    }
  }

  // void createAppLink(String? path) async {
  //   final UserData = {"section": sectionId.toString(), "topic":topicId.toString() , "topic_count":topicCount.toString(),"subTopicCount":subTopicCount.toString()};
  //   final uri = Uri.https("digividya.in", path ?? "", UserData);
  //   print("%%%%%%%%%%%%%%%%%%% ${uri} %%%%%%%%%%%%%%%%%%%%%");
  // }

// Define an asynchronous method to handle the completion of a subtopic
  _completedSubTopic() async {
    // Get the application support directory path
    String dirpath = (await getApplicationSupportDirectory()).path;
    // Create a File object for the appInfo.json file
    File jsonFile = File("$dirpath/appInfo.json");

    // Define the URL for the API endpoint
    String url = "https://digividya.in/DigiVidyaAPI/api/completedSubtopic";

    // Check if the jsonFile exists
    if (jsonFile.existsSync()) {
      try {
        // Read the JSON data from the file and decode it
        var jsonData = jsonDecode(jsonFile.readAsStringSync());
        // Get the user ID from the JSON data
        var userId = jsonData['User_Id'];

        // Prepare the user data for the API request
        var userData = {
          "user_id": userId.toString(),
          "topic_id": topicId.toString()
        };

        // Send a POST request to the API with the user data
        var response = await http.post(Uri.parse(url), body: userData);

        // Check if the response status code is 200 (OK)
        if (response.statusCode == 200) {
          // Decode the response body
          Map<String, dynamic> jsonResponse =
              jsonDecode(response.body.toString().replaceAll("\n", " "));

          // Check if the jsonResponse is not empty
          if (jsonResponse.isNotEmpty) {
            // Print the jsonResponse for debugging
            print(
                "%%%%%%%%%%%%%%%%%%%%%%%% $jsonResponse %%%%%%%%%%%%%%%%%%%%%%%");

            // Check if the 'completedIDs' in the jsonResponse is a list
            if (jsonResponse['completedIDs'] is List) {
              // Print the completed subtopic list for debugging
              print(
                  "%%%%%%%%%%%%%%%%%%%%%%% Completed Suntopic List ${jsonResponse['completedIDs']} %%%%%%%%%%%%%%%%%%%");

              // Iterate through the completed IDs
              for (int i = 0; i < jsonResponse['completedIDs'].length; i++) {
                // Print debugging information during the iteration
                print(
                    "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Iterating JsonResponse for Match %%%%%%%%%%%%%%%%%%%%%%%%%%%");
                print(" ${int.parse(jsonResponse['completedIDs'][i])}");
                print(" $subTopicIds ");

                // Check if the current completed ID is in the subTopicIds list
                if (subTopicIds
                    .contains(int.parse(jsonResponse['completedIDs'][i]))) {
                  // Print debugging information if a match is found
                  print(
                      "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SubTopic Id Matches %%%%%%%%%%%%%%%%%%%%%%%%%%%");
                  // Update the add_InVisibleList to mark the subtopic as completed
                  add_InVisibleList[subTopicIds.indexOf(
                      int.parse(jsonResponse['completedIDs'][i]))] = true;
                }
              }
              // Set the value of completedListOfBool to true
              completedListOfBool.value = true;
            } else {
              // Handle case where 'completedIDs' is not a list (optional)
            }
          } else {
            // Handle case where jsonResponse is empty (optional)
          }
        }
      } on http.ClientException catch (e) {
        // Handle HTTP client exceptions (optional)
      }
    } else {
      // Handle case where jsonFile does not exist (optional)
    }
  }

  getFileNames() async {
    String dir = (await getApplicationSupportDirectory()).path.toString();
    print(Directory(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/")
        .listSync());

    if (Directory(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/")
        .existsSync()) {
      Directory(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/")
          .listSync()
          .forEach((element) {
            AssignmentFileName.add(element.path.split("/").last.toString());
          });
    }
    return;
  }
}
