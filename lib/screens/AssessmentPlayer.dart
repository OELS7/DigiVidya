import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
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
  int section = 0,
      topic = 0,
      topicCount = 0,
      subTopic = 0,
      subTopicCount = 0,
      itemPointer = 0;
  String assessFilePath = "";
  List<dynamic> contentUrls = [];
  List<String> FileName = [];
  List<String> deviceFileName = [];
  List<String> deviceFilePath = [];
  ValueNotifier<bool> heartButtonPressed = ValueNotifier<bool>(false);

  var pageContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDiviceFileName();
  }

  @override
  Widget build(BuildContext context) {
    var argument = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;

    pageContext = context;

    assessFilePath = argument['htmlFilePath'];
    section = argument['section'];
    topic = argument['topic'];
    topicCount = argument['topicCount'];
    subTopic = argument['subTopic'];
    subTopicCount = argument['subTopicCount'];
    itemPointer = argument['itemPointer'];
    contentUrls = argument['contentUrls'];
    FileName = argument['FileName'];

    (contentUrls.length == 1 || itemPointer == contentUrls.length - 1)
        ? ""
        : _startDownload(fileUrl: contentUrls[itemPointer + 1]);

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            BackButton(
              onPressed: () {
                _onBackButtonPressed();
              },
            ),
            Text("Back")
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width * 1,
      ),
      body: SafeArea(
        child: InAppWebView(
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

            controller.loadUrl(
                urlRequest: URLRequest(url: Uri.parse(assessFilePath)));
          },
          //for assignment full screen exit
          onConsoleMessage: (controller, consoleMessage) {
            if (consoleMessage.message == "exit") {
              controller.evaluateJavascript(source: """
                                        document.exitFullscreen();
                                        """);

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

  /// Play next content
  ///
  /// This method opent the next content depending on the type of the content i.e. video file or assessment file by checking there extention.
  void _goToNextVideo(BuildContext assessmentDialogBox) async {
    if (itemPointer != contentUrls.length - 1) {
      String DirPath = (await getApplicationSupportDirectory()).path;
      Directory AssessmentDirectory = Directory(
          "$DirPath/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer].split(".zip").first}/");
      if (AssessmentDirectory.existsSync()) {
        await AssessmentDirectory.delete(recursive: true).then((_) {
          String fileExtension =
              FileName[itemPointer + 1].toString().split(".").last.toString();

          switch (fileExtension) {
            case "mp4":
              _playSpecificFile(
                  filePath:
                      "$DirPath/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Video/${FileName[itemPointer + 1]}");
              break;
            case "zip":
              _playSpecificFile(
                  filePath:
                      "$DirPath/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer + 1]}");
              break;
            default:
          }
        });
      }
    } else {
      //Exit The loop goto bannerAdd page
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var LikeDialogBox = context;
          return LikeDialog(
            yesButton: () {
              heartButtonPressed.value = true;
              _likeSubTopic();

              Future.delayed(
                Duration(milliseconds: 70),
                () {
                  Navigator.of(LikeDialogBox).pop();
                },
              );
            },
            noButton: () async {
              String dir = (await getApplicationSupportDirectory()).path;
              File jsonFile = File("$dir/appInfo.json");
              var jsonData = jsonDecode(jsonFile.readAsStringSync());
              String user_Id = jsonData['User_Id'].toString();
              String subTopic_Id = jsonData['subTopic_Id'].toString();
              // _setSubTopicCompleted(user_Id: user_Id, subTopic_Id: subTopic_Id);
              _demoprogrees(
                  user_Id: user_Id,
                  topic_Id: topic.toString(),
                  subTopic_Id: subTopic_Id);
              Future.delayed(Duration(milliseconds: 300), () {
                Navigator.pushReplacementNamed(pageContext, "/bannerAd",
                    arguments: {
                      "section": section,
                      "topic": topic,
                      "topicCount": topicCount,
                      "subTopicCount": subTopicCount
                    });
              });
              Navigator.of(LikeDialogBox).pop();
            },
            heartButtonPressed: heartButtonPressed,
          );
        },
      );
    }
  }

  /// Download Funtion
  ///
  /// This method download the assessment or video file from server using threading technique and store the specified path.
  _startDownload({required String fileUrl}) async {
    //for video download
    if (fileUrl.split("/").last.split(".").last == "mp4") {
      //API Call http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchSections
      // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/public/$fileUrl";
      String url = "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl";
      String dir = (await getApplicationSupportDirectory()).path;

      File videoFile = File(
          "$dir/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Video/${FileName[itemPointer + 1]}");

      if (!videoFile.existsSync()) {
        ReceivePort mainThreadReceiver = ReceivePort();

        // Inititalizing the thread
        await Isolate.spawn(_downloadContent, {
          "url": url,
          "location": videoFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listning thread response
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
      //For assignment download
      //API call
      // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchSections/$fileUrl";
      String url = "https://digividya.in/DigiVidyaAPI/laravel/public/$fileUrl";
      String dir = (await getApplicationSupportDirectory()).path;

      File AssessmentZipFile = File(
          "$dir/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/${FileName[itemPointer + 1]}");
// Old Assessment file deletion operation
      if (!AssessmentZipFile.existsSync()) {
        if ((itemPointer + 1) < deviceFilePath.length) {
          if (await File(deviceFilePath[itemPointer + 1].toString())
              .existsSync()) {
            File(deviceFilePath[itemPointer + 1].toString())
                .deleteSync(recursive: true);
          }
        }

        ReceivePort mainThreadReceiver = ReceivePort();
        // Inititalizing the thread
        await Isolate.spawn(_downloadContent, {
          "url": url,
          "location": AssessmentZipFile.path,
          "sendPort": mainThreadReceiver.sendPort
        });

        // Listning thread response
        mainThreadReceiver.listen((message) {
          if (message is String) {
            if (message.isNotEmpty && (message.toString() != "download fail")) {
              print("Assessment Zip File Downloading");
              print("$message % Downloaded");
            } else {
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
        if (FileName[itemPointer] != deviceFileName[itemPointer]) {
          // await File(deviceFilePath[itemPointer]).delete(recursive: true);

          // ReceivePort mainThreadReceiver = ReceivePort();
          // // Inititalizing the thread
          // await Isolate.spawn(_downloadContent, {
          //   "url": url,
          //   "location": AssessmentZipFile.path,
          //   "sendPort": mainThreadReceiver.sendPort
          // });

          // // Listning thread response
          // mainThreadReceiver.listen((message) {
          //   if (message is String) {
          //     if (message.isNotEmpty &&
          //         (message.toString() != "download fail")) {
          //       print("Assessment Zip File Downloading");
          //       print("$message % Downloaded");
          //     } else {
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           var dialogContext = context;
          //           return InternetErrorDialog(
          //             internetErrorDialogContext: dialogContext,
          //             message:
          //                 "Low internet connection . Please check your internet.",
          //           );
          //         },
          //       );
          //       print("Download Fail");
          //     }
          //   }
          // });
        }
      }
    }
  }

  /// Pay Specific File
  ///
  /// This method open the next screen depending on the media type.
  void _playSpecificFile({required String filePath}) async {
    String fileExtension = filePath.split("/").last.split('.').last.toString();

    switch (fileExtension) {
      case "mp4":
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
      case "zip":
        Directory AssessmentDirectory =
            Directory("${filePath.split("/").last.split(".zip").first}/");
        //If assignment exist already
        if (AssessmentDirectory.existsSync()) {
          File assessmentHtmlFile = File(
              "${filePath.split("/").last.split(".zip").first}/story_html5.html");
          if (assessmentHtmlFile.existsSync()) {
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
          //Extract ZipFile
          String dir = (await getApplicationSupportDirectory()).path;
          Directory AssessmentDirectory = Directory(
              "$dir/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/");
          ZipFile.extractToDirectory(
                  zipFile: File(filePath), destinationDir: AssessmentDirectory)
              .then((_) {
            File assessmentHtmlFile = File(
                "${filePath.split("/").last.split(".zip").first}/story_html5.html");

            if (assessmentHtmlFile.existsSync()) {
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

  ///function for like pop_up
  ///
  ///This method store the like and view of the selected subtopic.
  void _likeSubTopic() async {
    String dir = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dir/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    try {
      String user_Id = jsonData['User_Id'].toString();
      String subTopic_Id = jsonData['subTopic_Id'].toString();

      var sendUserData = {"user_id": user_Id, "subtopic_id": subTopic_Id};
      //API call for like subtopic
      String api_Url =
          "https://digividya.in/DigiVidyaAPI/api/storeLikesForSubtopic";

      // String api_Url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/storeLikesForSubtopic";

      var response = await http.post(Uri.parse(api_Url), body: sendUserData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        if (jsonResponse['status']) {
          jsonData['subTopic_Id'] = "";

          jsonFile.writeAsStringSync(jsonEncode(jsonData));
          //this will store the user view.
          // _setSubTopicCompleted(user_Id: user_Id, subTopic_Id: subTopic_Id);
          _demoprogrees(
              user_Id: user_Id,
              topic_Id: topic.toString(),
              subTopic_Id: subTopic_Id);
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
      print("This Occured when Client Exception Happened.. :${e.toString()}");
    } on Exception catch (e) {
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
      print("This Occured when any Exception happened : ${e.toString()}");
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

  // Insted of _setsubtopiccompleted use _demoprogress API Call funtion
  void _demoprogrees(
      {required String user_Id,
      // required String section_Id,
      required String topic_Id,
      required String subTopic_Id}) async {
    String Api_url = "https://digividya.in/DigiVidyaAPI/api/insertUserProgress";

    var userData = {
      "user_id": user_Id,
      // "section_id": section_Id,
      "topic_id": topic_Id,
      "subtopic_id": subTopic_Id
    };
    var response = await http.post(Uri.parse(Api_url), body: userData);
    if (response.statusCode == 200) {
      print("${response.body.replaceAll("\n", " ")}");
    }
  }

  Future<bool> _onBackButtonPressed() async {
    return (await showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) {
            var dialogBoc = context;
            return exitAssessment(
              yesButtonFuntion: () {
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
                Navigator.of(dialogBoc).pop(false);
              },
            );
          },
        )) ??
        false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // contentUrls.clear();
    // FileName.clear();
  }

  _getDiviceFileName() async {
    String directory = (await getApplicationSupportDirectory()).path;

    if (Directory(
            "$directory/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/")
        .existsSync()) {
      Directory(
              "$directory/Section_${section}/Topic_${topic}/subTopic_${subTopic}/Assessment/")
          .listSync()
          .forEach((element) {
        if (element is File) {
          deviceFileName
              .add(path.basename(element.path).toString().split(".").first);
          deviceFilePath.add(element.path.toString());
        }
      });
    }
  }
}

/// Downloading content method
///
/// This method download the content using threading technique and store the content on define path.
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
