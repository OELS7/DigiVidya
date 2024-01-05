import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/commingSoonAlertBox.dart';
import 'package:digividya/widgets/DownloadDialogBox.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
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
  final FixedExtentScrollController _fixedExtentScrollController =
      FixedExtentScrollController();
  final ValueNotifier<double> _valueNotifier = ValueNotifier<double>(0.0);
  Connectivity _connectivity = Connectivity();
  ValueNotifier<dynamic> dataFatched = ValueNotifier(false);
  late ConcatenatingAudioSource playList;
  late bgAudioPlayer player;
  Map<String, dynamic> subTopicCardsImage = {};
  Map<String, dynamic> subTopicCardsAudio = {};
  Map<String, dynamic> subTopicsLikes = {};
  Map<String, dynamic> subTopicView = {};
  Map<String, dynamic> urls = {};
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

  int sectionId = 0,
      topicId = 0,
      subTopicId = 0,
      subTopicCount = 0,
      Likes = 0,
      Views = 0,
      topicCount = 0;
  String subTopicCardImg = "", audioName = "";

  int sectionNumber = 0, topicNumber = 0, partNumber = 0;

  double test = 0.0;
  var _downloadDialogBoxContext;
  var pageContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkConnectivity();
    _fixedExtentScrollController.addListener(() => onScroll());
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;

    sectionId = argument['section'];
    topicId = argument['topic'];
    subTopicCount = argument['subTopicCount'];
    topicCount = argument['topicCount'];

    pageContext = context;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              BackButton(
                onPressed: () {
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
                return subTopicList(subTopicCount);
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

  subTopicList(int subTopicCount) {
    List<Widget> subTopicCards = [];

    for (int i = 0; i < subTopicCount; i++) {
      subTopicCards.add(Card(
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
                      image: MemoryImage(imageByteData[i]), fit: BoxFit.fill)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      GestureDetector(
                        onTap: () async {
                          player.stopAudio();

                          if (contentUrls.length != 0) {
                            _PlayContent(
                                contentList: contentUrls, FileName: FileName);
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                var commingSoonContext = context;
                                return commingSoonAlertbox(
                                    comingSoonDialogContext:
                                        commingSoonContext);
                              },
                            );
                          }
                        },
                        child: Container(
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
                      )
                    ],
                  ),
                ))
          ],
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
    int downloaded = 0;

    List<List<int>> chunks = [];

    try {
      final url = Uri.parse(
          "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl");
      var request = new http.Request('GET', url);
      var response = http.Client().send(request);

      response.asStream().listen((http.StreamedResponse r) {
        r.stream.listen((List<int> chunk) {
          // Display percentage of completion
          debugPrint(
              'downloadPercentage: ${downloaded / r.contentLength! * 100}');

          chunks.add(chunk);
          downloaded += chunk.length;
          _valueNotifier.value = (downloaded / r.contentLength!);
        }, onDone: () async {
          // Display percentage of completion
          debugPrint(
              'downloadPercentage: ${downloaded / r.contentLength! * 100}');
          _valueNotifier.value = (downloaded / r.contentLength!);
          // Save the file
          File file = new File(fileSaveLocatio);
          final Uint8List bytes = Uint8List(r.contentLength!);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          if (!await file.exists()) {
            await file
                .create(recursive: true)
                .then(
                    (value) => file.writeAsBytes(bytes, mode: FileMode.append))
                .then((_) {
              _playSpecificFile(ContentFileAddress: file.path);
            });
          } else {
            await file.delete(recursive: true).then((value) {
              file
                  .create(recursive: true)
                  .then(
                      (value) => file.writeAsBytes(bytes, mode: FileMode.write))
                  .then((value) {
                _playSpecificFile(ContentFileAddress: file.path);
              });
            });
          }
        });
      });
    } on http.ClientException catch (e) {
      print(e);
      setState(() {
        _valueNotifier.value = 0.0;
      });
      Navigator.of(_downloadDialogBoxContext).pop();
      showDialog(
        context: context,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
    }
  }

  getSubTopicDetails() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    // String url =
    //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchTopSubtopics";
    String url = "https://digividya.in/DigiVidyaAPI/api/fetchTopSubtopics";

    var userData = {"topic_id": topicId.toString()};
    if (jsonFile.existsSync()) {
      var response = await http.post(Uri.parse(url), body: userData);

      try {
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse =
              jsonDecode(response.body.toString().replaceAll("\n", " "));

          if (jsonResponse.isNotEmpty) {
            setState(() {
              subTopicDetails = jsonResponse['sub_topics'];
              subTopicIds = jsonResponse['subtopic_ids'];
              subTopicCardsImage = jsonResponse['subtopics_img'];
              subTopicCardsAudio = jsonResponse['subtopics_aud'];
              subTopicsLikes = jsonResponse['subtopics_likes'];
              subTopicView = jsonResponse['subtopics_views'];
              urls = jsonResponse['all_list'];
              contentUrls = urls[subTopicIds[0]];

              contentUrls.forEach((element) {
                FileName.add(element.toString().split("/").last.trim());
              });

              print(
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< $FileName >>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

              subTopicId = int.parse(subTopicIds[0]);
              // subTopicTitle = subTopicDetails[0]['DST_NAME'];

              subTopicCardImg = subTopicCardsImage['${subTopicIds[0]}'];
              // Likes = subTopicsLikes['${subTopicIds[0]}'];
              // Views = subTopicView['${subTopicIds[0]}'];

              subTopicCardsImage.forEach((key, value) {
                imageByteData.add(Base64Decoder().convert(value));
              });

              subTopicDetails.forEach((element) {
                subTopicTitle.add(element['DST_NAME']);
              });

              subTopicsLikes.forEach((key, value) {
                subTopicLikesCount.add(value.toString());
              });

              subTopicView.forEach((key, value) {
                subTopicViewsCount.add(value.toString());
              });
            });
            dataFatched.value = true;
          } else {}
        } else {
          // Show Dialog that indicates the internal server Error.
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
                    getSubTopicDetails();
                  },
                  ButtonText: "reload");
            },
          );
        }
      } on http.ClientException catch (e) {
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
                    getSubTopicDetails();
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
                    getSubTopicDetails();
                  },
                  ButtonText: "try again");
            },
          );
        }

        print(e.message.toString());
      }
    }
    return;
  }

  onScroll() {
    if (_fixedExtentScrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          subTopicId =
              int.parse(subTopicIds[_fixedExtentScrollController.selectedItem]);

          // subTopicTitle =
          //     subTopicDetails[_fixedExtentScrollController.selectedItem]
          //         ['DST_NAME'];

          subTopicCardImg = subTopicCardsImage[
              '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          // Likes = subTopicsLikes[
          //     '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];
          // Views = subTopicView[
          //     '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          contentUrls =
              urls[subTopicIds[_fixedExtentScrollController.selectedItem]];

          FileName.clear();
          contentUrls.forEach((element) {
            FileName.add(element.toString().split("/").last.trim());
          });

          player.playNextTrack(
              nextTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          subTopicId =
              int.parse(subTopicIds[_fixedExtentScrollController.selectedItem]);

          // subTopicTitle =
          //     subTopicDetails[_fixedExtentScrollController.selectedItem]
          //         ['DST_NAME'];

          subTopicCardImg = subTopicCardsImage[
              '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          contentUrls =
              urls[subTopicIds[_fixedExtentScrollController.selectedItem]];

          FileName.clear();
          contentUrls.forEach((element) {
            FileName.add(element.toString().split("/").last.trim());
          });

          // Likes = subTopicsLikes[
          //     '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          // Views = subTopicView[
          //     '${subTopicIds[_fixedExtentScrollController.selectedItem]}'];

          player.playPreviousTrack(
              previousTrackIndex: (_fixedExtentScrollController.selectedItem));
        });
      });
    }
  }

  generateAudioFile() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());

    for (var audioTracks = 0; audioTracks < subTopicCount; audioTracks++) {
      audioFileName.add(subTopicDetails[audioTracks]['DST_AUD_PATH']
          .split("/")
          .last
          .split(".mp3")
          .first);
    }
    print("from Server : $audioFileName");
    print(" ");
    for (var audioTracks = 0; audioTracks < subTopicCount; audioTracks++) {
      File audioFile = File(
          "$dirPath/Digividya/Section_$sectionId/AudioFile/topicAudio_${topicId}/subTopic_${audioTracks + 1}.mp3");

      if (!audioFile.existsSync()) {
        print("For First time");
        audioFile.createSync(recursive: true);

        // Creating list of audio file name to store this list into the json file
        demolist.add(audioFileName[audioTracks]);

        await audioFile.writeAsBytes(List<int>.from(Base64Decoder()
            .convert(subTopicCardsAudio['${subTopicIds[audioTracks]}'])));
        subTopicAudioFilePath.add(audioFile.path);
      } else {
        //var jsonData = jsonDecode(jsonFile.readAsStringSync());
        // fetching old list of File name from json file
        deviceAudioFileName = jsonData['subTopicAudio'];

        print("SubTopic AudioList : $deviceAudioFileName");

        // Checking File name precent in device in the json file and
        //compaire with server File name index by index
        if (deviceAudioFileName.isEmpty) {
          audioFile.createSync(recursive: true);

          // Creating list of audio file name to store this list into the json file
          demolist.add(audioFileName[audioTracks]);

          await audioFile.writeAsBytes(List<int>.from(Base64Decoder()
              .convert(subTopicCardsAudio['${subTopicIds[audioTracks]}'])));
          subTopicAudioFilePath.add(audioFile.path);
        } else {
          if (deviceAudioFileName[audioTracks] != audioFileName[audioTracks]) {
            print("file name not match");

            print("\n ");
            print("Befor changing file name : ${deviceAudioFileName}");
            // Changing the old audio file name of device json file
            // with new audio file name
            setState(() {
              deviceAudioFileName[audioTracks] = audioFileName[audioTracks];
              demolist.add(audioFileName[audioTracks]);
            });

            print('\n ');
            print("After Changing file Name :${deviceAudioFileName}");

            // writing the new content to the existing file

            audioFile.writeAsBytesSync(List<int>.from(Base64Decoder()
                .convert(subTopicCardsAudio['${subTopicIds[audioTracks]}'])));

            subTopicAudioFilePath.add(audioFile.path);
          } else {
            demolist.add(audioFileName[audioTracks]);
            subTopicAudioFilePath.add(audioFile.path);
            print("file name match");
          }
        }
      }
    }
    deviceAudioFileName = demolist;
    jsonData['subTopicAudio'] = deviceAudioFileName;
    print("This is device audio File Name : ${deviceAudioFileName}");
    print('\n');
    print("Sub Topic Audio file Name List ${jsonData['subTopicAudio']}");
    print("\n");
    print("This is JSON DATA :$jsonData");

    jsonFile.writeAsStringSync(jsonEncode(jsonData));
    print('\n');
    print(jsonFile.readAsStringSync());
    return;
  }

  void _setSubTopicViewCount({required String directoryPath}) async {
    // File object of json file
    File jsonFile = File("$directoryPath/appInfo.json");

    var userid = 0, subtopic_Id = 0;

    if (jsonFile.existsSync()) {
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      setState(() {
        userid = jsonData['User_Id'];
        subtopic_Id = jsonData['subTopic_Id'];
      });
      var userData = {
        "user_id": userid.toString(),
        "subtopic_id": subtopic_Id.toString()
      };

      // String url =
      //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/storeViewsForSubtopic";
      String url =
          "https://digividya.in/DigiVidyaAPI/api/storeViewsForSubtopic";

      var response = await http.post(Uri.parse(url), body: userData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        if (jsonResponse.isNotEmpty) {}
      } else {
        // show Dialog or message
        showDialog(
          context: context,
          builder: (context) {
            var internetErrorContext = context;
            return InternetErrorDialog(
              internetErrorDialogContext: internetErrorContext,
              message: "Low internet connection . Please check your internet.",
            );
          },
        );
      }
    }
  }

  Future<bool> _onBackButtonPressed() {
    return Future.delayed(
      Duration(milliseconds: 300),
      () {
        player.stopAudio();
        Navigator.pushReplacementNamed(context, "/TopicPage",
            arguments: {"section": sectionId, "topic_count": topicCount});
        return false;
      },
    );
  }

  void _checkConnectivity() async {
    final _checkConnectivity = await _connectivity.checkConnectivity();
    if (_checkConnectivity == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Low internet connection . Please check your internet.",
          );
        },
      );
    } else {
      getSubTopicDetails().then((_) {
        generateAudioFile().then((_) {
          playList = ConcatenatingAudioSource(
              useLazyPreparation: true,
              children: List.generate(subTopicCount,
                  (index) => AudioSource.file(subTopicAudioFilePath[index])));
          player = bgAudioPlayer(concatenatingAudioSource: playList);
          player.initAudioPlayer();
        });
      });
    }
  }

  _PlayContent(
      {required List<dynamic> contentList,
      required List<String> FileName}) async {
    String dir = (await getApplicationSupportDirectory()).path;
    switch (contentList[0].toString().split("/").last.split(".").last) {
      case "mp4":
        print(
            "<<<<<<<<<<<<<<<<<< This Url Contains Mp4 Extension >>>>>>>>>>>>>>>>>>>>>");
        File videoFile = File(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Video/${FileName[0]}");
        if (videoFile.existsSync()) {
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
          String dirPath = (await getApplicationSupportDirectory()).path;
          File JsonFile = File("$dirPath/appInfo.json");
          var jsonData = jsonDecode(JsonFile.readAsStringSync());
          jsonData['subTopic_Id'] = subTopicId;

          JsonFile.writeAsStringSync(jsonEncode(jsonData));

          _downloadLession(
              fileUrl: contentList[0], fileSaveLocatio: videoFile.path);
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
        // print(
        //     "<<<<<<<<<<<<<<<< This Url Contains Zip Extension >>>>>>>>>>>>>>>>>>>>>>");

        Directory AssessmrntDirectory = Directory(
            "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/");

        if (AssessmrntDirectory.existsSync()) {
          File assessmentHtmlFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");
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
        } else {
          File AssessmentZipFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0]}");

          if (!AssessmentZipFile.existsSync()) {
            String dirPath = (await getApplicationSupportDirectory()).path;
            File JsonFile = File("$dirPath/appInfo.json");
            var jsonData = jsonDecode(JsonFile.readAsStringSync());
            jsonData['subTopic_Id'] = subTopicId;

            JsonFile.writeAsStringSync(jsonEncode(jsonData));

            _downloadLession(
                fileUrl: contentList[0],
                fileSaveLocatio: AssessmentZipFile.path);
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
            ZipFile.extractToDirectory(
                    zipFile: AssessmentZipFile,
                    destinationDir: Directory(
                        "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/"))
                .then((_) {
              File assessmentHtmlFile = File(
                  "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");
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
    }
  }

  void _playSpecificFile({required String ContentFileAddress}) async {
    String dir = (await getApplicationSupportDirectory()).path;
    if (ContentFileAddress.split(".").last == "mp4") {
      setState(() {
        Future.delayed(
          const Duration(milliseconds: 900),
          () {
            _setSubTopicViewCount(directoryPath: dir);
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
        Navigator.of(_downloadDialogBoxContext).pop();
      });
    } else {
      //Playing Assessment File
      setState(() {
        ZipFile.extractToDirectory(
                zipFile: File(ContentFileAddress),
                destinationDir: Directory(
                    "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/"))
            .then((_) {
          File assessmentHtmlFile = File(
              "$dir/Section_${sectionId}/Topic_${topicId}/subTopic_${subTopicId}/Assessment/${FileName[0].split(".").first.toString()}/story_html5.html");
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
        // print(
        //     "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $ContentFileAddress &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        Navigator.of(_downloadDialogBoxContext).pop();
      });
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
}
