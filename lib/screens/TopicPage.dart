import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:digividya/widgets/InternalServerError.dart';
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
  // List<String> topicLikes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkConnectivity();

    _fixedExtentScrollController.addListener(
      () => onScroll(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;

    sectionID = argument['section'];
    topicCount = argument['topic_count'];

    pageContext = context;

    (TopicProgress.isEmpty && hideAndshow_CompletedIcon.isEmpty)
        ? _getTemBoolValue()
        : () {};

    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            leading: Row(
              children: [
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
              if (value is bool) {
                if (value) {
                  return ValueListenableBuilder(
                    valueListenable: progressOfTopic,
                    builder: (context, value, child) {
                      if (value is bool) {
                        if (value) {
                          return subTopic(sectionID, topicCount);
                        } else {
                          return subTopic(sectionID, topicCount);
                        }
                      } else {
                        return subTopic(sectionID, topicCount);
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.115,
                          // color: Colors.blue,
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
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ))),
    );
  }

  subTopic(int sectionNumber, int topic) {
    List<Widget> topicCards = [];
    for (int i = 0; i < topic; i++) {
      topicCards.add(GestureDetector(
        onTap: () async {
          print("Start button pressesd");
          (topicDetails[i]['subtopic_count'] != 0) ? player.stopAudio() : {};
          (UserName == "Guest" && i != 0)
              ? showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var LockCardContext = context;
                    return lockcard(LockCardDialogContext: LockCardContext);
                  },
                )
              : (topicDetails[i]['subtopic_count'] != 0)
                  ? Navigator.of(context)
                      .pushReplacementNamed('/subTopicPage', arguments: {
                      'section': sectionID,
                      'topic': topic_id,
                      'topicCount': topicCount,
                      'subTopicCount': subTopicCount
                    })
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
        child: Card(
            //color: Colors.blue,
            shadowColor: Colors.black,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
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
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    //left: MediaQuery.of(context).size.width * 0.19,
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
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.43,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    Text("${topicLike[i]}")
                                  ],
                                ),
                                // LinearProgressIndicator(),
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
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.0135,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.005),
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
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.053,
                    left: MediaQuery.of(context).size.width * 0.77,
                    child: Text(
                      "${!TopicProgress[i].isNaN ? (TopicProgress[i] * 100).round() : 0} %",
                      style: TextStyle(color: Colors.white),
                    )),
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
    return ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        magnification: 1.0,
        itemExtent: 530,
        controller: _fixedExtentScrollController,
        children: topicCards);
  }

  onScroll() {
    if ((_fixedExtentScrollController.position.userScrollDirection ==
        ScrollDirection.reverse)) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          topic_id = topicIds[_fixedExtentScrollController.selectedItem];

          // topicTile = topicDetails[_fixedExtentScrollController.selectedItem]
          //     ['DT_NAME'];

          // subTopicCount = int.parse(
          //     subTopicCountList[_fixedExtentScrollController.selectedItem]);

          // Likes = topicLikes[
          //     '${topicIds[_fixedExtentScrollController.selectedItem]}'];
          // Views = topicView[
          //     '${topicIds[_fixedExtentScrollController.selectedItem]}'];
          player.playNextTrack(
              nextTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
      print("upward scrolling");
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          topic_id = topicIds[_fixedExtentScrollController.selectedItem];

          // topicTile = topicDetails[_fixedExtentScrollController.selectedItem]
          //     ['DT_NAME'];

          // subTopicCount = int.parse(
          //     subTopicCountList[_fixedExtentScrollController.selectedItem]);
          // Likes = topicLikes[
          //     '${topicIds[_fixedExtentScrollController.selectedItem]}'];
          // Views = topicView[
          //     '${topicIds[_fixedExtentScrollController.selectedItem]}'];

          player.playPreviousTrack(
              previousTrackIndex: _fixedExtentScrollController.selectedItem);
        });
        // player.rpeatAudio();
      });
      print("revers scrolling");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      player.stopAudio();
    }

    if (state == AppLifecycleState.detached) {
      player.stopAudio();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    topicDetails.clear();
    topicsCardsAudio.clear();
    deviceAudioFileName.clear();
    topicIds.clear();
    updatedAudioFileName.clear();
    listFileNameFromServer.clear();
    imageByteData.clear();
    topicTitle.clear();
    topicLike.clear();
    topicsCardsImage.clear();
    topicCardsAudio.clear();
    topicView.clear();

    player.disposeAudio();

    WidgetsBinding.instance.removeObserver(this);

    _fixedExtentScrollController.dispose();

    super.dispose();
  }

  getAllTopicDetails() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchSecTopics";
    String url = "https://digividya.in/DigiVidyaAPI/api/fetchSecTopics";

    if (jsonFile.existsSync()) {
      try {
        var jsonData = jsonDecode(jsonFile.readAsStringSync());
        UserName = jsonData['UserName'].toString();
        Map<String, dynamic> userData = {'section_id': sectionID.toString()};
        var response = await http.post(Uri.parse(url), body: userData);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonRespons =
              jsonDecode(response.body.toString().replaceAll("\n", " "));

          setState(() {
            topicCount = jsonRespons['topic_count'];
            topicDetails = jsonRespons['topics'];
            topicIds = jsonRespons['topic_ids'];
            topic_id = topicIds[0];
            topicsCardsImage = jsonRespons['topic_img'];
            topicCardsAudio = jsonRespons['topic_aud'];
            cardImage = topicsCardsImage['${topicIds[0]}'];

            topicsCardsImage.forEach((key, value) {
              imageByteData.add(Base64Decoder().convert(value));
            });

            topicDetails.forEach((element) {
              topicTitle.add(element['DT_NAME']);
            });

            topicDetails.forEach((element) {
              topicLike.add(element['likes_counts'].toString());
              topicView.add(element['views_count'].toString());
              subTopicCountList.add(element['subtopic_count'].toString());
            });
            subTopicCount = int.parse(subTopicCountList[0]);
          });

          var jsonData = jsonDecode(jsonFile.readAsStringSync());

          jsonData['topic_id'] = topic_id;

          jsonFile.writeAsStringSync(jsonEncode(jsonData));

          print(jsonFile.readAsStringSync());
          _getCompletedSubtopicList();

          dataFatched.value = true;

          print("This is jsonData: $jsonRespons");
        } else {
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
        print("Exception From ${e.message}");
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
                    Future.delayed(Duration(milliseconds: 50), () {
                      getAllTopicDetails();
                    });
                    Navigator.of(internalServerErrorContext).pop(false);
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
                    Future.delayed(
                      Duration(milliseconds: 50),
                      () {
                        getAllTopicDetails();
                      },
                    );
                    Navigator.of(internalServerErrorContext).pop(false);
                  },
                  ButtonText: "try again");
            },
          );
        }
      }
    } else {}
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

  Future<bool> onBackPress() async {
    return Future.delayed(
      Duration.zero,
      () {
        Future.delayed(
          Duration(milliseconds: 300),
          () {
            Navigator.pushReplacementNamed(context, "/");
          },
        );
        return false;
      },
    );
  }

  void _checkConnectivity() async {
    final _checkConnectivity = await _connectivity.checkConnectivity();
    if (_checkConnectivity == ConnectivityResult.none) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
    } else {
      getAllTopicDetails().then((_) {
        getUpdatedAudioFile().then((_) {
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

  getUpdatedAudioFile() async {
    String directory = (await getApplicationSupportDirectory()).path;

    List<Directory> listofFileDirectory = [];
    List<String> fileName = [];

    for (var audioTracks = 0; audioTracks < topicCount; audioTracks++) {
      listFileNameFromServer.add(topicDetails[audioTracks]['DT_AUD_PATH']
          .split("/")
          .last
          .split(".mp3")
          .first);
    }

    for (int tAudioTrack = 0; tAudioTrack < topicCount; tAudioTrack++) {
      File topicAudioFile = File(
          "$directory/DigiVidya/Section_$section_Id/AudioFile/Topic_${tAudioTrack + 1}/${listFileNameFromServer}.mp3");

      if (!topicAudioFile.existsSync()) {
        topicAudioFile.createSync(recursive: true);

        //reading and decode the audio content and write to the audio file
        await topicAudioFile.writeAsBytes(
            List<int>.from(Base64Decoder()
                .convert(topicCardsAudio['${topicIds[tAudioTrack]}'])),
            flush: true);

        // Storing the path of each audio file for creating playList and Play
        topicsCardsAudio.add(topicAudioFile.path);
      } else {
        Directory("$directory/DigiVidya/Section_$section_Id/AudioFile/")
            .listSync(followLinks: true)
            .forEach(
          (element) {
            // print("%%%%%%%%%%%%%%%% $element %%%%%%%%%%%%%%%%%");
            if (element is Directory) {
              listofFileDirectory.add(element);
            }
          },
        );

        for (Directory audioDirectory in listofFileDirectory) {
          try {
            Directory("${audioDirectory.path}/").listSync().forEach((element) {
              fileName
                  .add(path.basename(element.path).toString().split('.').first);
            });
          } catch (e) {}
        }

        if (listFileNameFromServer[tAudioTrack] != fileName[tAudioTrack]) {
          topicAudioFile.renameSync(
              "$directory/DigiVidya/Section_$section_Id/AudioFile/Topic_${tAudioTrack + 1}/${listFileNameFromServer[tAudioTrack]}.mp3");

          //reading and decode the audio content and write to the audio file
          await topicAudioFile.writeAsBytes(
              List<int>.from(Base64Decoder()
                  .convert(topicCardsAudio['${topicIds[tAudioTrack]}'])),
              flush: true);

          // Storing the path of each audio file for creating playList and Play
          topicsCardsAudio.add(topicAudioFile.path);
        } else {
          // Storing the path of each audio file for creating playList and Play
          topicsCardsAudio.add(topicAudioFile.path);
        }

        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%% $fileName %%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      }
    }
  }

  void _getCompletedSubtopicList() async {
    String dirpath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirpath/appInfo.json");

    String url = "https://digividya.in/DigiVidyaAPI/api/completedTopics";

    if (jsonFile.existsSync()) {
      try {
        var jsonData = jsonDecode(jsonFile.readAsStringSync());
        var userId = jsonData['User_Id'];

        var userData = {
          "user_id": userId.toString(),
          "section_id": sectionID.toString()
        };
        var response = await http.post(Uri.parse(url), body: userData);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse =
              jsonDecode(response.body.toString().replaceAll("\n", " "));
          if (jsonResponse.isNotEmpty) {
            completedSubtopicList = jsonResponse['count_of_IDs'];

            // This block store the bool value of the completed icon to show or hide icon in hideAndShow_CompletedIcon List.
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

            // This block store the progress of each card in TopicProgres List
            for (int itemProgress = 0;
                itemProgress < topicCount;
                itemProgress++) {
              TopicProgress[itemProgress] =
                  completedSubtopicList[topicIds[itemProgress].toString()] /
                      int.parse(subTopicCountList[itemProgress]);
            }

            print(
                "%%%%%%%%%%%%%%%%%%% Topic Progress : ${TopicProgress} %%%%%%%%%%%%%%%%%%%%%");

            progressOfTopic.value = true;
          }
          // print(
          //     "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $completedSubtopicList %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        } else {}
      } catch (e) {}
    }
  }

  void _getTemBoolValue() {
    for (int completedItem = 0; completedItem < topicCount; completedItem++) {
      hideAndshow_CompletedIcon.add(false);
      TopicProgress.add(0.0);
    }
  }
}
