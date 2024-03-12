// import 'package:audioplayers/audioplayers.dart';
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/commingSoonAlertBox.dart';
import 'package:digividya/widgets/exitAppDialog.dart';
import 'package:digividya/widgets/resumeAndPlayDialog.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

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
  int sectionCount = 0, topicCount = 0, sectionId = 0;
  String sectionTitle = "",
      sectionDescription = "",
      sectionCardImage = "",
      image = "";
  List<dynamic> sectionDetail = [];
  List<String> cardsAudioFilePath = [];
  List<dynamic> deviceAudioFileName = [];
  List<String> updatedAudioFileName = [];
  List<String> listFileNameFromServer = [];
  // Map<String, dynamic> sectionLikes = {};
  // Map<String, dynamic> sectionView = {};
  Map<String, dynamic> cardImage = {};
  Map<String, dynamic> cardsAudio = {};
  List<dynamic> sectionIds = [];
  List<dynamic> imageByteData = [];
  List<String> cardsTitle = [];
  List<String> cardsLike = [];
  List<String> cardsView = [];
  List<String> _sectionId = [];
  List<String> _topicCount = [];
  late bgAudioPlayer player;
  late ConcatenatingAudioSource playList;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _ShowHoldSession();

    _checkConnectivity();

    _fixedExtentScrollController.addListener(() {
      onScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: SafeArea(
            child: ValueListenableBuilder(
          valueListenable: dataFatched,
          builder: (context, value, child) {
            if (value is bool) {
              if (value) {
                return topics();
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
        )),
      ),
    );
  }

  topics() {
    List<Widget> topic = [];
    for (int i = 0; i < sectionCount; i++) {
      topic.add(
        GestureDetector(
            onTap: () async {
              (sectionDetail[i]['topic_count'] != 0) ? player.stopAudio() : {};

              setState(() {});

              if (sectionDetail[i]['topic_count'] != 0) {
                Navigator.of(context).pushReplacementNamed('/TopicPage',
                    arguments: {
                      'section': sectionId,
                      'topic_count': sectionDetail[i]['topic_count']
                    });
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var comingSoonContext = context;
                    return commingSoonAlertbox(
                        comingSoonDialogContext: comingSoonContext);
                  },
                );
              }
            },
            child: Card(
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
                      top: MediaQuery.of(context).size.height * 0.43,
                      left: 0.0,
                      right: 0.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                cardsTitle[i],
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                softWrap: false,
                                textAlign: TextAlign.center,
                                maxLines: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                      Text("${cardsLike[i]}")
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
                                      Text("${cardsView[i]}")
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.45,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.005,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.005),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(3, 45, 96, 1),
                                        Color.fromRGBO(1, 118, 211, 1),
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
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            )),
        // ),
      );
    }

    return ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        magnification: 1.0,
        itemExtent: 530,
        controller: _fixedExtentScrollController,
        children: topic);
  }

  // Change the cards title ,view count, likes count, image and audio description
  onScroll() async {
    if ((_fixedExtentScrollController.position.userScrollDirection ==
        ScrollDirection.reverse)) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          sectionId =
              sectionDetail[_fixedExtentScrollController.selectedItem]['DS_ID'];
          // topicCount = sectionDetail[_fixedExtentScrollController.selectedItem]
          //     ['topic_count'];

          player.playNextTrack(
              nextTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
      print("upward scrolling");
      print("Section ${_fixedExtentScrollController.selectedItem+1} Audio File Name : ${listFileNameFromServer[_fixedExtentScrollController.selectedItem]}");
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          sectionId =
              sectionDetail[_fixedExtentScrollController.selectedItem]['DS_ID'];
          // topicCount = sectionDetail[_fixedExtentScrollController.selectedItem]
          //     ['topic_count'];

          player.playPreviousTrack(
              previousTrackIndex: _fixedExtentScrollController.selectedItem);
        });
      });
      // print("revers scrolling");
      // print("Section ${_fixedExtentScrollController.selectedItem+1} Audio File Name : ${listFileNameFromServer[_fixedExtentScrollController.selectedItem]}");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      player.stopAudio();
    }

    if (state == AppLifecycleState.detached) {
      player.stopAudio();
    }

    // if (state == AppLifecycleState.resumed) {
    //   player.initAudioPlayer();
    // }
  }

  @override
  void dispose() {
    sectionDetail.clear();
    cardsAudioFilePath.clear();
    deviceAudioFileName.clear();
    updatedAudioFileName.clear();
    listFileNameFromServer.clear();
    // sectionLikes.clear();
    // sectionView.clear();
    cardImage.clear();
    cardsAudio.clear();
    sectionIds.clear();
    imageByteData.clear();
    cardsTitle.clear();
    cardsLike.clear();
    cardsView.clear();
    _sectionId.clear();
    _topicCount.clear();
    player.disposeAudio();
    _fixedExtentScrollController.removeListener(() {});
    _fixedExtentScrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // For API calls
  //This method get the all required details for creating cards on screen
  //and store the users current progress in the json file.
  getSectionDetails() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    // API url
    // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchSections";
     String url = "https://digividya.in/DigiVidyaAPI/api/fetchSections";

    // jsonFile use for storing the progress and user details for futher use.
    File jsonFile = File("$dirPath/appInfo.json");

    if (jsonFile.existsSync()) {
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      //print(jsonData['User_Id'] jsonData['User_Id']);
      try {
        var userData = {'user_id': jsonData['User_Id'].toString()};
        var response = await http.post(Uri.parse(url), body: userData);

        if (response.statusCode == 200) {
          // here restructure the response that come from server

          var jsonRespons =
              jsonDecode(response.body.toString().replaceAll("\n", " "));

          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $jsonRespons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

          if (jsonRespons.isNotEmpty) {
            setState(() {
              sectionCount = jsonRespons['section_count'];
              sectionDetail = jsonRespons['section_details'];
              sectionIds = jsonRespons['section_ids'];
              // sectionLikes = jsonRespons['section_likes'];
              // sectionView = jsonRespons['section_views'];
              cardImage = jsonRespons['section_img'];
              cardsAudio = jsonRespons['section_aud'];
              sectionTitle = sectionDetail[0]['DS_NAME'];
              sectionId = sectionDetail[0]['DS_ID'];
              // topicCount = sectionDetail[0]['topic_count'];

            });
            cardImage.forEach((key, value) {
              imageByteData.add(Base64Decoder().convert(value));
            });

            sectionDetail.forEach((element) {
              cardsTitle.add(element['DS_NAME']);
            });

            sectionDetail.forEach((element) {
              cardsLike.add(element["likes_counts"].toString());
              cardsView.add(element["views_count"].toString());
            });

            // print("Section ${0+1} Audio File Name : ${listFileNameFromServer[0]}");

            dataFatched.value = true;
            // print(cardsAudio); Base64Decoder().convert(image)
            //store the section id for the user progress
            jsonData['section_id'] = sectionDetail[0]['DS_ID'];
            print(jsonData);
            jsonFile.writeAsStringSync(
              jsonEncode(jsonData),
            );

            print(jsonFile.readAsStringSync());
          } else {}
        } else {
          showDialog(
            context: context,
            builder: (context) {
              var dialogContext = context;
              return InternetErrorDialog(
                internetErrorDialogContext: dialogContext,
                message:
                    "Internal server problem has occurred. Please try again.",
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
            builder: (context) {
              var internalServerErrorContext = context;
              return internalServerError(
                  internalServerErrorContext: internalServerErrorContext,
                  ErrorTitle: "Internet Error",
                  description:
                      " Looks like you might be offline. Please check your internet connection and try again.",
                  retryButton: () {
                    Future.delayed(
                      Duration(milliseconds: 50),
                      () {
                        getSectionDetails();
                      },
                    );
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
                      " Internal server problem has occurred. Please try again.",
                  retryButton: () {
                    getSectionDetails().then((_) {
                      Navigator.of(context).pop(internalServerErrorContext);
                    });
                  },
                  ButtonText: "try again");
            },
          );
        }
      }
    } else {}
    return;
  }

  // generateCardsAudioFile() async {
  //   var dirPath = (await getApplicationSupportDirectory()).path;
  //   File jsonFile = File("$dirPath/appInfo.json");
  //   var jsonData = jsonDecode(jsonFile.readAsStringSync());

  //   for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
  //     listFileNameFromServer.add(sectionDetail[audioTracks]['DS_AUD_PATH']
  //         .split("/")
  //         .last
  //         .split(".mp3")
  //         .first);
  //   }

  //   for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
  //     File cardaudio = File(
  //       "$dirPath/Digividya/Section_${audioTracks + 1}/AudioFile/section_${audioTracks + 1}.mp3",
  //     );

  //     //Checking audio file is present or not
  //     //if audio file is not present then create audio file
  //     //then assign the list of file name comming from server to the device
  //     //for storing the file name in the json file for futher use.
  //     if (!cardaudio.existsSync()) {
  //       cardaudio.createSync(recursive: true);
  //       //assigning the list of file name comming from server to the temp variable
  //       updatedAudioFileName.add(listFileNameFromServer[audioTracks]);
  //       //reading and decode the audio content and write to the audio file
  //       cardaudio.writeAsBytes(List<int>.from(
  //           Base64Decoder().convert(cardsAudio['${sectionIds[audioTracks]}'])));
  //       // Storing the path of each audio file for creating playList and Play
  //       cardsAudioFilePath.add(cardaudio.path);
  //       print(cardsAudioFilePath);
  //     } else {
  //       // This block execute when the user open app 2nd time
  //       //it read the files name from the json file
  //       //
  //       deviceAudioFileName = jsonData['sectionAudioFileName'];

  //       // Checking any update come from the server
  //       //if there is any update come from server then
  //       //overwrite the existing audio file with new content
  //       // change the existing list of file name with new file name
  //       //for futher use.
  //       if (deviceAudioFileName.isEmpty) {
  //         cardaudio.createSync(recursive: true);
  //         //assigning the list of file name comming from server to the temp variable
  //         updatedAudioFileName.add(listFileNameFromServer[audioTracks]);
  //         //reading and decode the audio content and write to the audio file
  //         cardaudio.writeAsBytes(List<int>.from(Base64Decoder()
  //             .convert(cardsAudio['${sectionIds[audioTracks]}'])));
  //         // Storing the path of each audio file for creating playList and Play
  //         cardsAudioFilePath.add(cardaudio.path);
  //         print(cardsAudioFilePath);
  //       } else {
  //         if ((deviceAudioFileName[audioTracks] !=
  //             listFileNameFromServer[audioTracks])) {
  //           // Changing the old audio file name of device json file
  //           // with new audio file name
  //           print("\n Before change : $deviceAudioFileName");
  //           updatedAudioFileName.add(listFileNameFromServer[audioTracks]);

  //           // writing the new content to the existing file
  //           //
  //           cardaudio.writeAsBytes(List<int>.from(Base64Decoder()
  //               .convert(cardsAudio['${sectionIds[audioTracks]}'])));
  //           //
  //           cardsAudioFilePath.add(cardaudio.path);
  //         } else {
  //           //
  //           updatedAudioFileName.add(listFileNameFromServer[audioTracks]);
  //           //
  //           cardsAudioFilePath.add(cardaudio.path);
  //         }
  //       }
  //     }
  //   }
  //   // getAudioFileUpdate();
  //   deviceAudioFileName = updatedAudioFileName;
  //   print("\n After Change : $deviceAudioFileName");
  //   jsonData['sectionAudioFileName'] = deviceAudioFileName;
  //   jsonFile.writeAsStringSync(jsonEncode(jsonData));
  //   return;
  // }

  Future<bool> onBackButtonPress() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            var exitDialogContex = context;
            return exitAppDialog(dialogcontect: exitDialogContex);
          },
        )) ??
        false;
  }

  _ShowHoldSession() async {
    String DirPath = (await getApplicationSupportDirectory()).path;

    File jsonFile = File("$DirPath/appInfo.json");

    var jsonData = jsonDecode(jsonFile.readAsStringSync());

    if (!jsonData.containsKey("ResumData")) {
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
      jsonData["ResumData"] = resumeData;
      jsonFile.writeAsStringSync(jsonEncode(jsonData));
    } else {
      var startOver = jsonData['ResumData'];
      if (startOver['VideoData']['filePath'].toString().isEmpty &&
          startOver['AssessmentData']['filePath'].toString().isEmpty) {
        print(
            "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< resume Data is Empty >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return resumeAndPlayDialog(resume: () {}, startOver: () {});
          },
        );
      }
    }
  }

  void _checkConnectivity() async {
    final _checkConnectivity = await _connectivity.checkConnectivity();
    if (_checkConnectivity == ConnectivityResult.none) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Looks like you might be offline. Please check your internet connection and try again.",
          );
        },
      );
    } else {
      getSectionDetails().then((_) {
        getAudioFileUpdate().then((_) {
          //creating playlist for playing cards audio
          playList = ConcatenatingAudioSource(
              useLazyPreparation: true,
              children: List.generate(sectionCount,
                  (index) => AudioSource.file(cardsAudioFilePath[index])));

          //initialize the player
          player = bgAudioPlayer(concatenatingAudioSource: playList);

          // start playing 1st card audio
          player.initAudioPlayer();
        });
      });
    }
  }

  getAudioFileUpdate() async {
    String directory = (await getApplicationSupportDirectory()).path;
    List<Directory> listooFileDirectory = [];

    List<String> fileName = [];

    for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
      listFileNameFromServer.add(sectionDetail[audioTracks]['DS_AUD_PATH']
          .split("/")
          .last
          .split(".mp3")
          .first);
    }

    // Creating audi file for different section
    for (var audioTracks = 0; audioTracks < sectionCount; audioTracks++) {
      File audioFile = File(
          "$directory/DigiVidya/Section_${audioTracks + 1}/AudioFile/${listFileNameFromServer[audioTracks]}.mp3");

      if (!audioFile.existsSync()) {
        audioFile.createSync(recursive: true);
        //reading and decode the audio content and write to the audio file
        audioFile.writeAsBytes(
            List<int>.from(Base64Decoder()
                .convert(cardsAudio['${sectionIds[audioTracks]}'])),
            flush: true);
        // Storing the path of each audio file for creating playList and Play
        cardsAudioFilePath.add(audioFile.path);
      } else {
        Directory("$directory/DigiVidya/")
            .listSync(followLinks: true)
            .forEach((element) {
          if (element is Directory) {
            listooFileDirectory.add(element);
          }
        });

        // Iterating list of director for get Audio file Name for check any update come from server.
        for (Directory directory in listooFileDirectory) {
          try {
            Directory("${directory.path}/AudioFile/")
                .listSync()
                .forEach((element) {
              fileName
                  .add(path.basename(element.path).toString().split(".").first);
            });
          } catch (e) {
            print(
                "Error got while processing list of file from list of Directory");
          }
        }

        // Checking for Update in audio file
        if (listFileNameFromServer[audioTracks] != fileName[audioTracks]) {
          audioFile.rename(
              "$directory/DigiVidya/Section_${audioTracks + 1}/AudioFile/${listFileNameFromServer[audioTracks]}.mp3");

          audioFile.writeAsBytes(
              List<int>.from(Base64Decoder()
                  .convert(cardsAudio['${sectionIds[audioTracks]}'])),
              flush: true);

          cardsAudioFilePath.add(audioFile.path);
        } else {
          // Storing the path of each audio file for creating playList and Play
          cardsAudioFilePath.add(audioFile.path);
        }
      }
    }
  }
}
