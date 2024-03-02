import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
// import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:digividya/widgets/LikeDialog.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:chewie/chewie.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/widgets/QuiteVideoPlayerDialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class videoWidget extends StatefulWidget {
  String VideoFile = "";
  int minutes;
  int seconds;
  int section = 0;
  int topicNumber = 0;
  int topicCount = 0;
  int subTopicNumber = 0;
  int subTopicCount = 0;
  int itemPointer = 0;
  List<dynamic> contentUrls;
  List<String> FileName;

  videoWidget(
      {super.key,
      required this.VideoFile,
      required this.minutes,
      required this.seconds,
      required this.section,
      required this.topicNumber,
      required this.topicCount,
      required this.subTopicNumber,
      required this.subTopicCount,
      required this.itemPointer,
      required this.contentUrls,
      required this.FileName});

  @override
  State<videoWidget> createState() => _videoWidgetState(
      VideoFile: VideoFile,
      minutes: minutes,
      seconds: seconds,
      section: section,
      topicNumber: topicNumber,
      topicCount: topicCount,
      subTopicNumber: subTopicNumber,
      subTopicCount: subTopicCount,
      contentUrls: contentUrls,
      FileName: FileName,
      itemPointer: itemPointer);
}

class _videoWidgetState extends State<videoWidget> with WidgetsBindingObserver {
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;

  String VideoFile = "";
  int minutes;
  int seconds;
  int section = 0;
  int topicNumber = 0;
  int topicCount = 0;
  int subTopicNumber = 0;
  int subTopicCount = 0;
  int itemPointer = 0;
  List<dynamic> contentUrls;
  List<String> FileName;
  List<String> deviceFileName = [];
  List<String> deviceFilePath = [];
  var pageContext;

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
    WidgetsBinding.instance.addObserver(this);
    _getDeviceFileName();
    //widget.VideoFile
    videoPlayerController = VideoPlayerController.file(File(widget.VideoFile));

    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        allowFullScreen: true,
        startAt: ((widget.minutes != 0) && (widget.seconds != 0))
            ? Duration(minutes: widget.minutes, seconds: widget.seconds)
            : const Duration(minutes: 00),
        aspectRatio: 763 / 1640);

    videoPlayerController.addListener(_videoListener);
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;

    (contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : _startDownload(FileUrl: contentUrls[itemPointer + 1]);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            // height: MediaQuery.of(context).size.height * 0.,
            width: MediaQuery.of(context).size.width * 1,
          ),
          leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          barrierColor: Color.fromARGB(226, 37, 37, 37),
          builder: (context) {
            var exitVideoContext = context;
            return quiteVideoPlayerDialog(
              yesButton: () {
                print("**************** backButton pressed ****************");
                Future.delayed(
                  Duration(milliseconds: 300),
                  () {
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
                return true;
              },
              noButton: () {
                Navigator.pop(exitVideoContext, false);
              },
            );
          },
        )) ??
        false;
  }

  void _playContent(
      {required List<dynamic> contentUrls,
      required List<String> fileName,
      required int itemPointer}) async {
    String dir = (await getApplicationSupportDirectory()).path;
    // contentUrls.length == 1
    //     ? ""
    //     : contentUrls[itemPointer + 1]
    //         .toString()
    //         .split("/")
    //         .last
    //         .split(".")
    //         .last
    print(
        "=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=> Item Pinter : ${itemPointer} =>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>");
    switch ((contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : contentUrls[itemPointer + 1]
            .toString()
            .split("/")
            .last
            .split(".")
            .last) {
      case "mp4":
        print(
            "<<<<<<<<<<<<<<<<<< This Url Contains Mp4 Extension >>>>>>>>>>>>>>>>>>>>>");
        // File videoFile = File(
        //     "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Video/${fileName[itemPointer]}");
        Navigator.pushReplacementNamed(context, '/vidoePage', arguments: {
          "filePath":
              "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Video/${fileName[itemPointer + 1]}",
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
      case "zip":
        print(
            "<<<<<<<<<<<<<<<< This Url Contains Zip Extension >>>>>>>>>>>>>>>>>>>>>>");

        Directory AssessmentDirectroy = Directory(
            "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/");
        if (AssessmentDirectroy.existsSync()) {
          File htmlFile = File(
              "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story_html5.html");
          if (htmlFile.existsSync()) {
            //play Assessment File
            Future.delayed(Duration(milliseconds: 300), () {
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
              Navigator.pushReplacementNamed(context, '/assessmentPage',
                  arguments: {
                    "htmlFilePath":
                        "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story.html",
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
          File AssessmentZipFile = File(
              "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1]}");

          if (AssessmentZipFile.existsSync()) {
            ZipFile.extractToDirectory(
                    zipFile: AssessmentZipFile,
                    destinationDir: Directory(
                        "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/"))
                .then((_) async {
              File htmlFile = File(
                  "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story_html5.html");
              if (htmlFile.existsSync()) {
                //play Assessment File
                Future.delayed(Duration(milliseconds: 300), () {
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
                  Navigator.pushReplacementNamed(context, '/assessmentPage',
                      arguments: {
                        "htmlFilePath":
                            "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1].split(".zip").first}/story.html",
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

        Future.delayed(Duration(milliseconds: 300), () {
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
    if (FileUrl.toString().split("/").last.split(".").last == "mp4") {
      // for .mp4 Extension "http://192.168.1.19/prachi/DigiVidyaAPI/public/$fileUrl"
      // String Url = "http://192.168.1.19/prachi/DigiVidyaAPI/public/$FileUrl";
      String Url = "https://digividya.in/DigiVidyaAPI/laravel/public/$FileUrl";
      String dir = (await getApplicationSupportDirectory()).path;
      File videoFile = File(
          "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Video/${FileName[itemPointer + 1]}");

      if (!videoFile.existsSync()) {
        ReceivePort mainThreadReceiver = ReceivePort();

        await Isolate.spawn(_downloadContent, {
          "url": Url,
          "location": videoFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        mainThreadReceiver.listen((message) {
          if (message is String) {
            if (message.isNotEmpty && (message.toString() != "download fail")) {
              print("Video File Downloading");
              print("$message % Downloaded");
            } else {
              showDialog(
                context: context,
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
      //For .zip Extension
      // String Url =
          // "http://192.168.1.19/prachi/DigiVidyaAPI/public/$FileUrl";
      String Url = "https://digividya.in/DigiVidyaAPI/laravel/public/$FileUrl";
      String dir = (await getApplicationSupportDirectory()).path;

      File AssessmentZipFile = File(
          "$dir/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/${FileName[itemPointer + 1]}");
// Old Assessment file deletion operation
      if (!AssessmentZipFile.existsSync()) {
        if ((itemPointer + 1) < deviceFilePath.length) {
          if (await File(deviceFilePath[itemPointer + 1].toString())
              .existsSync()) {
            File(deviceFilePath[itemPointer + 1].toString())
                .deleteSync(recursive: true);
          }
        }

        // Create a ReceivePort to receive messages from the spawned Isolate
        ReceivePort mainThreadReceiver = ReceivePort();

        // Spawn an Isolate to download the content
        await Isolate.spawn(_downloadContent, {
          "url": Url,
          "location": AssessmentZipFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listen to messages from the spawned Isolate
        mainThreadReceiver.listen((message) {
          if (message is String) {
            if (message.isNotEmpty && message.toString() != "download fail") {
              print("Assessment File Downloading");
              print("$message % Downloaded");
            } else {
              // Show dialog for internet error
              showDialog(
                context: context,
                builder: (context) {
                  var dialogContext = context;
                  return InternetErrorDialog(
                    internetErrorDialogContext: dialogContext,
                    message:
                        "Low internet connection. Please check your internet.",
                  );
                },
              );
              print("Download Fail");
            }
          }
        });
      }

//       if (!AssessmentZipFile.existsSync()) {
//         ((deviceFilePath.isNotEmpty) && (deviceFilePath.length >1)) ? File(deviceFilePath[itemPointer+1]).deleteSync(recursive: true) : (){};
//         print("%%%%%%%%%%%% ${deviceFilePath[itemPointer + 1]} %%%%%%%%%%%%%%%%%%%%%%%%%");
// ReceivePort mainThreadReceiver = ReceivePort();

//           await Isolate.spawn(_downloadContent, {
//             "url": Url,
//             "location": AssessmentZipFile.path,
//             "sendPort": mainThreadReceiver.sendPort
//           });

//           mainThreadReceiver.listen((message) {
//             if (message is String) {
//               if (message.isNotEmpty &&
//                   (message.toString() != "download fail")) {
//                 print("Assessment File Downloading");
//                 print("$message % Downloaded");
//               } else {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     var dialogContext = context;
//                     return InternetErrorDialog(
//                       internetErrorDialogContext: dialogContext,
//                       message:
//                           "Low internet connection . Please check your internet.",
//                     );
//                   },
//                 );
//                 print("Download Fail");
//               }
//             }
//           });
//       }
    }
    return;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // FileName.clear();
    // contentUrls.clear();
    videoPlayerController.dispose();
    _chewieController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _showLikeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var LikeDialogBoxContext = context;
        return LikeDialog(yesButton: () {
          Future.delayed(
            Duration(milliseconds: 60),
            () {
              _likeSubTopic();
            },
          );
          Navigator.of(LikeDialogBoxContext).pop();
        }, noButton: () async {
          String dir = (await getApplicationSupportDirectory()).path;
          File jsonFile = File("$dir/appInfo.json");
          var jsonData = jsonDecode(jsonFile.readAsStringSync());
          String user_Id = jsonData['User_Id'].toString();
          String subTopic_Id = jsonData['subTopic_Id'].toString();
          _setCompletedSubTopic(user_Id: user_Id, subTopic_Id: subTopic_Id)
              .then((_) {
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

          Navigator.of(LikeDialogBoxContext).pop();
        });
      },
    );
  }

  _likeSubTopic() async {
    //int RadomNumber = Random().nextInt(10)+1;
    String dir = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dir/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    try {
      String user_Id = jsonData['User_Id'].toString();
      String subTopic_Id = jsonData['subTopic_Id'].toString();

      var sendUserData = {"user_id": user_Id, "subtopic_id": subTopic_Id};

      String api_Url =
          "https://digividya.in/DigiVidyaAPI/api/storeLikesForSubtopic";

      // String api_Url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/storeLikesForSubtopic";

      var response = await http.post(Uri.parse(api_Url), body: sendUserData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

            print("%%%%%%%%%%%%%%%%%%%%%%%%%% ${jsonResponse['status']} %%%%%%%%%%%%%%%%%%%%%%%%%%");

        if (jsonResponse['status']) {
          jsonData['subTopic_Id'] = "";

          jsonFile.writeAsStringSync(jsonEncode(jsonData));

          _setCompletedSubTopic(user_Id: user_Id, subTopic_Id: subTopic_Id)
              .then((_) {
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
      print("This Occured when Client Exception Happen.. :${e.toString()}");
    } on Exception catch (e) {
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
      print("This Occured when any Exception happen : ${e.toString()}");
    }
  }

  _setCompletedSubTopic(
      {required String user_Id, required String subTopic_Id}) async {
    // String Api_Url =
    //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateUserProgress";
    String Api_Url = "https://digividya.in/DigiVidyaAPI/api/updateUserProgress";
    String dir = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dir/appInfo.json");

    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    if (!jsonData.containsKey("completedSubTopic")) {
      var userData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
      var response = await http.post(Uri.parse(Api_Url), body: userData);
      if (response.statusCode == 200) {}
    } else {
      List completedSubTopicList = jsonData['completedSubTopic'];

      if (!completedSubTopicList.contains(subTopic_Id)) {
        completedSubTopicList.add(subTopic_Id);
        jsonData['completedSubTopic'] = completedSubTopicList;
      }

      var userData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
      var response = await http.post(Uri.parse(Api_Url), body: userData);
      if (response.statusCode == 200) {}
    }
  }

  void _videoListener() async {
    Duration _totalDuration = videoPlayerController.value.duration;
    Duration _currentPositionOfProgressIndicator =
        videoPlayerController.value.position;
    if (_currentPositionOfProgressIndicator == _totalDuration ||
        _currentPositionOfProgressIndicator >= _totalDuration) {
      if (itemPointer != contentUrls.length - 1) {
        if (File(widget.VideoFile).existsSync()) {
          File(widget.VideoFile).deleteSync(recursive: true);
          _chewieController.exitFullScreen();
/////////////////////////////////////////////////////////////////////////////////////////////////////

          _playContent(
              contentUrls: contentUrls,
              fileName: FileName,
              itemPointer: (itemPointer));

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        } else {
          _chewieController.exitFullScreen();

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
        File(widget.VideoFile).deleteSync(recursive: true);
        _chewieController.exitFullScreen();
        videoPlayerController.removeListener(_videoListener);
        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        _showLikeDialog();
      }
    } else {
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
    String directory = (await getApplicationSupportDirectory()).path;

    if (Directory(
            "$directory/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/")
        .existsSync()) {
      Directory(
              "$directory/Section_${section}/Topic_${topicNumber}/subTopic_${subTopicNumber}/Assessment/")
          .listSync()
          .forEach((element) {
        if (element is File) {
          deviceFileName
              .add(path.basename(element.path).toString().split(".").first);
          deviceFilePath.add(element.path.toString());
        }
      });
    }

    // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  $deviceFileName  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  }
}

void _downloadContent(Map<String, dynamic> message) {
  String fileUrl = message["url"].toString();
  String downloadLocation = message['location'].toString();
  final sendPort = message['sendPort'] as SendPort;
  int downloaded = 0;
  List<List<int>> chunks = [];

  try {
    final url = Uri.parse(fileUrl);
    var request = new http.Request('GET', url);
    var response = http.Client().send(request);

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        // debugPrint(
        //     'downloadPercentage: ${downloaded / r.contentLength! * 100}');

        chunks.add(chunk);
        downloaded += chunk.length;
        sendPort.send("${(downloaded / r.contentLength!)}");
      }, onDone: () async {
        // Display percentage of completion
        // debugPrint(
        //     'downloadPercentage: ${downloaded / r.contentLength! * 100}');
        sendPort.send("${(downloaded / r.contentLength!)}");
        // Save the file
        File file = new File(downloadLocation);
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file
            .create(recursive: true)
            .then((value) => file.writeAsBytes(bytes, mode: FileMode.append));
      }, onError: (_) {
        sendPort.send("download fail");
      });
    }, onError: (_) {
      sendPort.send("download fail");
    });
  } catch (e) {
    print(e.toString());
    sendPort.send("download fail");
  }
}
