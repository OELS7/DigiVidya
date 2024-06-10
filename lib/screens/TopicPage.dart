import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:digividya/widgets/InternalserverError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/Lock_Cards.dart';
import 'package:digividya/widgets/commingSoonAlertBox.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable

class topicPage extends StatefulWidget {
  topicPage({
    super.key,
  });

  @override
  State<topicPage> createState() => _topicPageState();
}

// ignore: camel_case_types
class _topicPageState extends State<topicPage> with WidgetsBindingObserver {
  final FixedExtentScrollController _fixedExtentScrollController =
      FixedExtentScrollController();
  Connectivity _connectivity = Connectivity();
  ValueNotifier<dynamic> dataFatched = ValueNotifier(false);
  ValueNotifier<bool> progressOfTopic = ValueNotifier<bool>(false);
  late ConcatenatingAudioSource playlist;

  late bgAudioPlayer player;
  var pageContext;
  double progressData = 0.0;
  int sectionID = 0,
      topicCount = 0,
      topic_id = 0,
      subTopicCount = 0,
      section_Id = 0;

  String topicTile = "", topicDescription = "", cardImage = "", UserName = "";

  List<dynamic> topicDetails = [];
  List<String> topicsCardsAudio = [];
  List<dynamic> deviceAudioFileName = [];
  List<dynamic> topicIds = [];
  List<String> updatedAudioFileName = [];
  List<String> listFileNameFromServer = [];
  List<dynamic> imageByteData = [];
  List<String> topicTitle = [];
  List<String> subTopicCountList = [];
  List<double> TopicProgress = [];
  // List<int> TopicsSubtopicCounts = [];
  // List<String> topicViews = [];
  List<String> topicLike = [];
  Map<String, dynamic> topicsCardsImage = {};
  Map<String, dynamic> topicCardsAudio = {};
  List<String> topicView = [];
  Map<String, dynamic> completedSubtopicList = {};
  List<bool> hideAndshow_CompletedIcon = [];
  ScreenshotController _screenshotController = ScreenshotController();
  // List<String> topicLikes = [];

@override
void initState() {
  // Calling parent class initState method
  super.initState();
  // Adding observer to monitor app lifecycle
  WidgetsBinding.instance.addObserver(this);
  // Checking connectivity when the widget is initialized
  _checkConnectivity();

  // Adding listener to the scroll controller
  _fixedExtentScrollController.addListener(() => onScroll());
}


@override
Widget build(BuildContext context) {
  // Extracting arguments from the route settings
  final argument = (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;

  // Parsing sectionID and topicCount from the arguments
  sectionID = (argument['section'] is String)
      ? int.parse(argument['section'].toString())
      : argument['section'];
  topicCount = (argument['topic_count'] is String)
      ? int.parse(argument['topic_count'].toString())
      : argument['topic_count'];

  // Storing the current context
  pageContext = context;

  // Checking if TopicProgress and hideAndshow_CompletedIcon lists are empty
  // If they are empty, calling _getTemBoolValue() method
  (TopicProgress.isEmpty && hideAndshow_CompletedIcon.isEmpty)
      ? _getTemBoolValue()
      : () {};

  return PopScope(
    // Preventing popping from the navigation stack
    canPop: false,
    child: Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            // Adding a custom back button and "Back" text to the app bar
            BackButton(
              onPressed: () {
                onBackPress();
              },
            ),
            Text("Back")
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width * 1,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: dataFatched,
          builder: (context, value, child) {
            // Checking if dataFetched is of type bool
            if (value is bool) {
              if (value) {
                // Returning the subTopic widget wrapped in Screenshot widget
                return ValueListenableBuilder(
                  valueListenable: progressOfTopic,
                  builder: (context, value, child) {
                    if (value is bool) {
                      return Screenshot(
                        child: subTopic(sectionID, topicCount),
                        controller: _screenshotController,
                      );
                    } else {
                      return Screenshot(
                        child: subTopic(sectionID, topicCount),
                        controller: _screenshotController,
                      );
                    }
                  },
                );
              } else {
                // Showing loading indicator if data is not yet fetched
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
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              // Showing loading indicator if dataFetched is not yet of type bool
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


  // Define a widget named subTopic that takes sectionNumber and topic as parameters
Widget subTopic(int sectionNumber, int topic) {
    // Initialize a list to hold the topic cards
    List<Widget> topicCards = [];
    // Loop through the number of topics to create each topic card
    for (int i = 0; i < topic; i++) {
      // Add a GestureDetector widget to the list for each topic
      topicCards.add(GestureDetector(
        // Define the onTap behavior for the GestureDetector
        onTap: () async {
          // Print a message when the start button is pressed
          print("Start button pressesd");
          // Stop the audio if the subtopic count is not zero
          (topicDetails[i]['subtopic_count'] != 0) ? player.stopAudio() : {};
          // Check if the user is a guest and the topic is not the first one
          (UserName == "Guest" && i != 0)
              // Show a dialog for locked cards
              ? showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var LockCardContext = context;
                    return lockcard(LockCardDialogContext: LockCardContext);
                  },
                )
              // If the subtopic count is not zero, navigate to the subTopicPage
              : (topicDetails[i]['subtopic_count'] != 0)
                  ? Navigator.of(context)
                      .pushReplacementNamed('/subTopicPage', arguments: {
                      'section': sectionID,
                      'topic': topic_id,
                      'topicCount': topicCount,
                      'subTopicCount': subTopicCount
                    })
                  // Show a coming soon dialog if there are no subtopics
                  : showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        var comingSoonContext = context;
                        return commingSoonAlertbox(
                            comingSoonDialogContext: comingSoonContext);
                      },
                    );
        },
        // Define the child widget of GestureDetector as a Card
        child: Card(
            // Set the shadow color of the card
            shadowColor: Colors.black,
            // Set the margin of the card
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            // Set the elevation of the card
            elevation: 25,
            // Set the shape of the card with rounded corners
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(58),
            ),
            // Use a Stack widget to overlay multiple children
            child: Stack(
              children: [
                // Container for the background image
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(58),
                      image: DecorationImage(
                          image: MemoryImage(imageByteData[i]),
                          fit: BoxFit.fill)),
                ),
                // Positioned widget for the completed icon
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    right: MediaQuery.of(context).size.width * 0.232,
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Visibility(
                        visible: hideAndshow_CompletedIcon[i],
                        child: LottieBuilder.asset(
                          "assets/Animation/9kASTq22vM.json",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          repeat: false,
                        ))),
                // Positioned widget for the topic title and other details
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.43,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Padding widget for the topic title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            child: Text(
                              topicTitle[i],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Padding widget for the like and view icons
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Row widget for the like icon and count
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/app_icons/heart.png',
                                      height: 30,
                                      width: 50,
                                    ),
                                    Text("${topicLike[i]}")
                                  ],
                                ),
                                // Row widget for the view icon and count
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/app_icons/ViewIcon.webp',
                                      height: 30,
                                      width: 50,
                                    ),
                                    Text("${topicView[i]}")
                                  ],
                                ),
                                // IconButton widget for sharing the topic
                                IconButton(
                                    onPressed: () async {
                                      // Define the path for the topic image
                                      File TopicImage = File(
                                          "${(await getApplicationSupportDirectory()).path}/Section${sectionID}/Topic${topic_id}/topic${topic_id}.png");
                                      // Define the user data for sharing
                                      final UserData = {
                                        "section": sectionID.toString(),
                                        "topic": topic_id.toString(),
                                        "topicCount": topicCount.toString(),
                                        "subTopicCount":
                                            subTopicCount.toString()
                                      };
                                      // Create the URI for sharing
                                      final uri = Uri.https(
                                          "digividya.in", "/subtopicpage.php", UserData);
                                      // Check if the topic image exists
                                      if(!TopicImage.existsSync()){
                                        // Capture the screenshot and save the image
                                        _screenshotController.capture().then((value) async{
                                          TopicImage.createSync(recursive: true);
                                          await TopicImage.writeAsBytes(value!).then((value) {
                                            ShareTopic(TopicImage.path , uri.toString());
                                          });
                                        });
                                      }
                                    },
                                    // Set the icon for the share button
                                    icon: Icon(Icons.share))
                              ],
                            ),
                          ),
                          // Container for the start button
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.0135,
                                bottom: MediaQuery.of(context).size.height * 0.005),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(0, 94, 86, 1),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                // Positioned widget for the circular progress indicator
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.038,
                    left: MediaQuery.of(context).size.width * 0.75,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.height * 0.055,
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        backgroundColor: Colors.white,
                        color: Color.fromARGB(240, 246, 77, 51),
                        value: !TopicProgress[i].isNaN ? TopicProgress[i] : 0.0,
                      ),
                    )),
                // Positioned widget for the progress percentage text
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.053,
                    left: MediaQuery.of(context).size.width * 0.77,
                    child: Text(
                      "${!TopicProgress[i].isNaN ? (TopicProgress[i] * 100).round() : 0} %",
                      style: TextStyle(color: Colors.white),
                    )),
                // Conditional rendering for guest user lock card
                (UserName == "Guest")
                    ? (i != 0)
                        ? Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/LockCardImage.webp",
                                    ),
                                    fit: BoxFit.fill)),
                          )
                        : SizedBox()
                    : SizedBox()
              ],
            )),
      ));
    }
    // Return a ListWheelScrollView to display the topic cards
    return ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        magnification: 1.0,
        itemExtent: 530,
        controller: _fixedExtentScrollController,
        children: topicCards);
  }


// Define the onScroll function
void onScroll() {
  // Check if the user is scrolling in the reverse direction (upward)
  if ((_fixedExtentScrollController.position.userScrollDirection == ScrollDirection.reverse)) {
    // Schedule a callback to be executed in the next frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Update the state of the widget
      setState(() {
        // Update the topic_id based on the selected item in the scroll controller
        topic_id = topicIds[_fixedExtentScrollController.selectedItem];

        // The following lines are commented out, but they would update various UI elements based on the selected item
        // topicTile = topicDetails[_fixedExtentScrollController.selectedItem]['DT_NAME'];
        // subTopicCount = int.parse(subTopicCountList[_fixedExtentScrollController.selectedItem]);
        // Likes = topicLikes['${topicIds[_fixedExtentScrollController.selectedItem]}'];
        // Views = topicView['${topicIds[_fixedExtentScrollController.selectedItem]}'];

        // Play the next track in the audio player based on the selected item
        player.playNextTrack(nextTrackIndex: (_fixedExtentScrollController.selectedItem));
      });
    });
    // Print a message indicating upward scrolling
    print("upward scrolling");
  } else {
    // Schedule a callback to be executed in the next frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Update the state of the widget
      setState(() {
        // Update the topic_id based on the selected item in the scroll controller
        topic_id = topicIds[_fixedExtentScrollController.selectedItem];

        // The following lines are commented out, but they would update various UI elements based on the selected item
        // topicTile = topicDetails[_fixedExtentScrollController.selectedItem]['DT_NAME'];
        // subTopicCount = int.parse(subTopicCountList[_fixedExtentScrollController.selectedItem]);
        // Likes = topicLikes['${topicIds[_fixedExtentScrollController.selectedItem]}'];
        // Views = topicView['${topicIds[_fixedExtentScrollController.selectedItem]}'];

        // Play the previous track in the audio player based on the selected item
        player.playPreviousTrack(previousTrackIndex: _fixedExtentScrollController.selectedItem);
      });
      // Optionally, repeat the audio track
      // player.repeatAudio();
    });
    // Print a message indicating reverse scrolling
    print("reverse scrolling");
  }
}


// Override the didChangeAppLifecycleState method
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  // Call the superclass implementation
  super.didChangeAppLifecycleState(state);

  // Check if the app lifecycle state is paused
  if (state == AppLifecycleState.paused) {
    // Stop the audio player
    player.stopAudio();
  }

  // Check if the app lifecycle state is detached
  if (state == AppLifecycleState.detached) {
    // Stop the audio player
    player.stopAudio();
  }
}


// Override the dispose method
@override
void dispose() {
  // Call the superclass implementation of dispose
  super.dispose();

  // Clear the topic details list
  topicDetails.clear();

  // Clear the topics cards audio list
  topicsCardsAudio.clear();

  // Clear the device audio file name list
  deviceAudioFileName.clear();

  // Clear the topic IDs list
  topicIds.clear();

  // Clear the updated audio file name list
  updatedAudioFileName.clear();

  // Clear the list of file names from the server
  listFileNameFromServer.clear();

  // Clear the image byte data list
  imageByteData.clear();

  // Clear the topic title list
  topicTitle.clear();

  // Clear the topic like list
  topicLike.clear();

  // Clear the topics cards image map
  topicsCardsImage.clear();

  // Clear the topic cards audio map
  topicCardsAudio.clear();

  // Clear the topic view list
  topicView.clear();

  // Dispose of the audio player
  player.disposeAudio();

  // Remove the observer from the WidgetsBinding instance
  WidgetsBinding.instance.removeObserver(this);

  // Dispose of the fixed extent scroll controller
  _fixedExtentScrollController.dispose();
}


// Function to get all topic details asynchronously
getAllTopicDetails() async {
  // Get the path to the application support directory
  String dirPath = (await getApplicationSupportDirectory()).path;

  // Create a File object for the JSON file
  File jsonFile = File("$dirPath/appInfo.json");

  // URL to fetch section topics
  String url = "https://digividya.in/DigiVidyaAPI/api/fetchSecTopics";

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    try {
      // Read and decode the JSON data from the file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());

      // Get the user name from the JSON data
      UserName = jsonData['UserName'].toString();

      // Create a map with the section ID as user data
      Map<String, dynamic> userData = {'section_id': sectionID.toString()};

      // Send a POST request to the URL with the user data
      var response = await http.post(Uri.parse(url), body: userData);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode the response body and remove new line characters
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        // Update the state with the fetched data
        setState(() {
          // Get the topic count from the response
          topicCount = jsonRespons['topic_count'];

          // Get the topic details from the response
          topicDetails = jsonRespons['topics'];

          // Get the topic IDs from the response
          topicIds = jsonRespons['topic_ids'];

          // Set the current topic ID to the first topic ID
          topic_id = topicIds[0];

          // Get the topic images from the response
          topicsCardsImage = jsonRespons['topic_img'];

          // Get the topic audio files from the response
          topicCardsAudio = jsonRespons['topic_aud'];

          // Set the card image to the image of the first topic
          cardImage = topicsCardsImage['${topicIds[0]}'];

          // Decode the topic images and add them to the image byte data list
          topicsCardsImage.forEach((key, value) {
            imageByteData.add(Base64Decoder().convert(value));
          });

          // Add the topic titles to the topic title list
          topicDetails.forEach((element) {
            topicTitle.add(element['DT_NAME']);
          });

          // Add the topic likes and views to their respective lists
          topicDetails.forEach((element) {
            topicLike.add(element['likes_counts'].toString());
            topicView.add(element['views_count'].toString());

            // Add the subtopic counts to the subtopic count list
            subTopicCountList.add(element['subtopic_count'].toString());
          });

          // Set the subtopic count to the count of the first topic
          subTopicCount = int.parse(subTopicCountList[0]);
        });

        // Update the JSON data with the current topic ID
        jsonData['topic_id'] = topic_id;

        // Write the updated JSON data back to the file
        jsonFile.writeAsStringSync(jsonEncode(jsonData));

        // Print the contents of the JSON file
        print(jsonFile.readAsStringSync());

        // Get the list of completed subtopics
        _getCompletedSubtopicList();

        // Set the data fetched flag to true
        dataFatched.value = true;

        // Print the response data
        print("This is jsonData: $jsonRespons");
      } else {
        // Show an internet error dialog if the response status code is not 200
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var dialogBoxContext = context;
            return InternetErrorDialog(
              internetErrorDialogContext: dialogBoxContext,
              message:
                  "Low internet connection . Please check your internet.",
            );
          },
        );
      }
    } on http.ClientException catch (e) {
      // Handle HTTP client exceptions
      print("Exception From ${e.message}");

      // Check the connectivity status
      final _checkConnectivity = await _connectivity.checkConnectivity();
      if (_checkConnectivity == ConnectivityResult.none) {
        // Show a no internet dialog if there is no internet connection
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
                  Future.delayed(Duration(milliseconds: 50), () {
                    getAllTopicDetails();
                  });
                  Navigator.of(InternalserverErrorContext).pop(false);
                },
                ButtonText: "reload");
          },
        );
      } else {
        // Show a poor connection dialog if the internet connection is poor
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
                  Future.delayed(
                    Duration(milliseconds: 50),
                    () {
                      getAllTopicDetails();
                    },
                  );
                  Navigator.of(InternalserverErrorContext).pop(false);
                },
                ButtonText: "try again");
          },
        );
      }
    }
  } else {
    // Handle the case where the JSON file does not exist
  }
  return;
}


  // generateCardsAudio() async {
  //   String dirPath = (await getApplicationSupportDirectory()).path;
  //   File jsonFile = File("$dirPath/appInfo.json");
  //   var jsonData = jsonDecode(jsonFile.readAsStringSync());

  //   for (var audioTracks = 0; audioTracks < topicCount; audioTracks++) {
  //     listFileNameFromServer.add(topicDetails[audioTracks]['DT_AUD_PATH']
  //         .split("/")
  //         .last
  //         .split(".mp3")
  //         .first);
  //   }
  //   print("from server : $listFileNameFromServer");
  //   for (var audioTracks = 0; audioTracks < topicCount; audioTracks++) {
  //     File cardAudio = File(
  //         "$dirPath/Digividya/Section_${section_Id}/AudioFile/topicAudio_${topic_id}/topic_${audioTracks + 1}.mp3");

  //     //Checking audio file is present or not
  //     //if audio file is not present then create audio file
  //     //then assign the list of file name comming from server to the device
  //     //for storing the file name in the json file for futher use.
  //     if (!cardAudio.existsSync()) {
  //       cardAudio.createSync(recursive: true);

  //       //assigning the list of file name comming from server to the temp variable
  //       updatedAudioFileName.add(listFileNameFromServer[audioTracks]);

  //       //reading and decode the audio content and write to the audio file
  //       await cardAudio.writeAsBytes(List<int>.from(Base64Decoder()
  //           .convert(topicCardsAudio['${topicIds[audioTracks]}'])));

  //       // Storing the path of each audio file for creating playList and Play
  //       topicsCardsAudio.add(cardAudio.path);
  //     } else {
  //       // This block execute when the user open app 2nd time
  //       //it read the files name from the json file
  //       //
  //       deviceAudioFileName = jsonData['topicAudioFileName'];

  //       // Checking any update come from the server
  //       //if there is any update come from server then
  //       //overwrite the existing audio file with new content
  //       // change the existing list of file name with new file name
  //       //for futher use.
  //       if (deviceAudioFileName.isEmpty) {
  //         updatedAudioFileName.add(listFileNameFromServer[audioTracks]);

  //         //
  //         await cardAudio.writeAsBytes(List<int>.from(Base64Decoder()
  //             .convert(topicCardsAudio['${topicIds[audioTracks]}'])));
  //         topicsCardsAudio.add(cardAudio.path);
  //       } else {
  //         if (listFileNameFromServer[audioTracks] !=
  //             deviceAudioFileName[audioTracks]) {
  //           //deviceAudioFileName[audioTracks] =
  //           // listFileNameFromServer[audioTracks];
  //           print("\n Befor change :$deviceAudioFileName");
  //           updatedAudioFileName.add(listFileNameFromServer[audioTracks]);

  //           //
  //           await cardAudio.writeAsBytes(List<int>.from(Base64Decoder()
  //               .convert(topicCardsAudio['${topicIds[audioTracks]}'])));
  //           topicsCardsAudio.add(cardAudio.path);
  //         } else {
  //           //
  //           updatedAudioFileName.add(listFileNameFromServer[audioTracks]);
  //           topicsCardsAudio.add(cardAudio.path);
  //         }
  //       }
  //     }
  //   }
  //   getUpdatedAudioFile();
  //   deviceAudioFileName = updatedAudioFileName;
  //   print("\n After Change : $deviceAudioFileName");
  //   jsonData['topicAudioFileName'] = deviceAudioFileName;

  //   jsonFile.writeAsStringSync(jsonEncode(jsonData));

  //   return;
  // }

// Function to handle back press with asynchronous operation
Future<bool> onBackPress() async {
  // Return a Future that completes immediately with a delay
  return Future.delayed(
    Duration.zero, // No initial delay
    () {
      // After the initial delay, set another delay of 300 milliseconds
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          // After the 300 milliseconds delay, navigate to the home screen
          Navigator.of(context).pushReplacementNamed("/");
        },
      );
      // Return false to indicate the back press is handled
      return false;
    },
  );
}


// Function to check connectivity and fetch topic details
void _checkConnectivity() async {
  // Check the current connectivity status
  final _checkConnectivity = await _connectivity.checkConnectivity();
  
  // If there is no internet connection
  if (_checkConnectivity == ConnectivityResult.none) {
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
  // If there is internet connection
  else {
    // Fetch topic details and updated audio files asynchronously
    getAllTopicDetails().then((_) {
      getUpdatedAudioFile().then((_) {
        // Create playlist and initialize audio player
        playlist = ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: List.generate(topicCount,
                (index) => AudioSource.file(topicsCardsAudio[index])));
        player = bgAudioPlayer(concatenatingAudioSource: playlist);
        player.initAudioPlayer();
      });
    });
  }
}


// Function to fetch and update audio files
getUpdatedAudioFile() async {
  // Get the directory path
  String directory = (await getApplicationSupportDirectory()).path;

  // Initialize lists to store directories and file names
  List<Directory> listofFileDirectory = [];
  List<String> fileName = [];

  // Extract file names from server paths
  for (var audioTracks = 0; audioTracks < topicCount; audioTracks++) {
    listFileNameFromServer.add(topicDetails[audioTracks]['DT_AUD_PATH']
        .split("/")
        .last
        .split(".mp3")
        .first);
  }

  // Iterate through each audio track
  for (int tAudioTrack = 0; tAudioTrack < topicCount; tAudioTrack++) {
    // Get the file path for the current audio track
    File topicAudioFile = File(
        "$directory/DigiVidya/Section_$section_Id/AudioFile/Topic_${tAudioTrack + 1}/${listFileNameFromServer[tAudioTrack]}.mp3");

    // If the file doesn't exist, create it
    if (!topicAudioFile.existsSync()) {
      topicAudioFile.createSync(recursive: true);

      // Read and decode the audio content, then write it to the audio file
      await topicAudioFile.writeAsBytes(
          List<int>.from(Base64Decoder()
              .convert(topicCardsAudio['${topicIds[tAudioTrack]}'])),
          flush: true);

      // Store the path of each audio file for creating playlist and playback
      topicsCardsAudio.add(topicAudioFile.path);
    } else {
      // Clear the list of file directories
      listofFileDirectory.clear();

      // Clear the list of file names
      fileName.clear();

      // Iterate through directories to get file names
      Directory("$directory/DigiVidya/Section_$section_Id/AudioFile/")
          .listSync(followLinks: true)
          .forEach(
        (element) {
          if (element is Directory) {
            listofFileDirectory.add(element);
          }
        },
      );

      // Get the file names from each directory
      for (Directory audioDirectory in listofFileDirectory) {
        try {
          Directory("${audioDirectory.path}/").listSync().forEach((element) {
            fileName
                .add(path.basename(element.path).toString().split('.').first);
          });
        } catch (e) {}
      }

      // Check if the file names from server match the existing file names
      if (listFileNameFromServer[tAudioTrack] != fileName[tAudioTrack]) {
        // Rename the audio file
        topicAudioFile.renameSync(
            "$directory/DigiVidya/Section_$section_Id/AudioFile/Topic_${tAudioTrack + 1}/${listFileNameFromServer[tAudioTrack]}.mp3");

        // Read and decode the audio content, then write it to the audio file
        await topicAudioFile.writeAsBytes(
            List<int>.from(Base64Decoder()
                .convert(topicCardsAudio['${topicIds[tAudioTrack]}'])),
            flush: true);

        // Store the path of each audio file for creating playlist and playback
        topicsCardsAudio.add(topicAudioFile.path);
      } else {
        // Store the path of each audio file for creating playlist and playback
        topicsCardsAudio.add(topicAudioFile.path);
      }

      print(
          "%%%%%%%%%%%%%%%%%%%%%%%%%% $fileName %%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }
  }
}


// Function to retrieve completed subtopic list
void _getCompletedSubtopicList() async {
  // Get the directory path
  String dirpath = (await getApplicationSupportDirectory()).path;
  // Create a file object
  File jsonFile = File("$dirpath/appInfo.json");
  // Set the URL for the API endpoint
  String url = "https://digividya.in/DigiVidyaAPI/api/completedTopics";

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    try {
      // Decode JSON data from the file
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      // Extract user ID from JSON data
      var userId = jsonData['User_Id'];

      // Prepare user data to send in the request body
      var userData = {
        "user_id": userId.toString(),
        "section_id": sectionID.toString()
      };
      // Send a POST request to the API endpoint
      var response = await http.post(Uri.parse(url), body: userData);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        // Check if the response is not empty
        if (jsonResponse.isNotEmpty) {
          // Update the completed subtopic list
          completedSubtopicList = jsonResponse['count_of_IDs'];

          // Update the list to show or hide completed icons
          topicIds.forEach((element) {
            int indexOfItem = topicIds.indexOf(element);
            int pointer = 0;
            if (completedSubtopicList.containsKey(element.toString()) &&
                (completedSubtopicList[element.toString()] ==
                    int.parse(subTopicCountList[pointer]))) {
              hideAndshow_CompletedIcon[indexOfItem] = true;
              pointer++;
            }
          });

          // Update the progress of each card
          for (int itemProgress = 0;
              itemProgress < topicCount;
              itemProgress++) {
            TopicProgress[itemProgress] =
                completedSubtopicList[topicIds[itemProgress].toString()] /
                    int.parse(subTopicCountList[itemProgress]);
          }

          // Print the topic progress
          print(
              "%%%%%%%%%%%%%%%%%%% Topic Progress : ${TopicProgress} %%%%%%%%%%%%%%%%%%%%%");

          // Update the progress value
          progressOfTopic.value = true;
        }
      }
    } catch (e) {}
  }
}


// Function to initialize temporary boolean values
void _getTemBoolValue() {
  for (int completedItem = 0; completedItem < topicCount; completedItem++) {
    hideAndshow_CompletedIcon.add(false);
    TopicProgress.add(0.0);
  }
}

// Function to share topic
void ShareTopic(String path, String uri) async {
  // Share the file and the URI
  // ignore: deprecated_member_use
  await Share.shareFiles([path], text: uri).then((_) {
    // Delete the shared file after sharing
    File(path).deleteSync(recursive: true);
  });
}

}
