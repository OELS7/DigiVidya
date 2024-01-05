import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/widgets/internalServerError.dart';
import 'package:http/http.dart' as http;
import 'package:digividya/screens/Register.dart';
import 'package:digividya/screens/AppIntroVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

bool _isCancelDownload = false;

class downloadScreen extends StatefulWidget {
  const downloadScreen({super.key});

  @override
  State<downloadScreen> createState() => _downloadScreenState();
}

class _downloadScreenState extends State<downloadScreen> {
  ValueNotifier<String> _progress = ValueNotifier("0");
  ValueNotifier<double> _percentage = ValueNotifier<double>(0.0);
  Connectivity _connectivity = Connectivity();
  var dialogBoxContext;
  var pagecontext;
  String language = "",
      userName = "",
      mobileNumber = "",
      City = "",
      device_Id = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var argument = (ModalRoute.of(context)!.settings.arguments ??
        <String, String>{}) as Map;
    pagecontext = context;

    _downloadvideo(
        language: argument['language'],
        userName: argument['userName'],
        mobilenumber: argument['mobilenumber'],
        city: argument['city'],
        device_id: argument['deviceid']);

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ValueListenableBuilder(
          valueListenable: _progress,
          builder: (context, value, child) {
            return ValueListenableBuilder(
              valueListenable: _percentage,
              builder: (context, percentage, child) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.42,
                      horizontal: 30),
                  //to show download progress
                  child: Column(children: [
                    LinearProgressIndicator(
                      color: (value == 100) ? Colors.green : Colors.blue,
                      minHeight: 20,
                      value: percentage,
                    ),
                    Text("$value % Downloaded")
                  ]),
                );
              },
            );
          },
        ),
      )),
    );
  }

  _downloadvideo(
      {required String language,
      required String userName,
      required String mobilenumber,
      required String city,
      required String device_id}) async {
    //API call for app intro
    var url =
        "https://digividya.in/assets/app_intro_video/$language/$language.mp4";
    String dir = (await getApplicationSupportDirectory()).path;
    String videoFilePath = File("$dir/intro_video/$language.mp4").path;
    ReceivePort _mainrecieverport = ReceivePort();

    // if(!File(videoFilePath).existsSync()){
    Isolate _isolate = await Isolate.spawn(_downloadthread, {
      "url": url,
      "downloadlocation": videoFilePath,
      "senderport": _mainrecieverport.sendPort
    });

    _mainrecieverport.listen((message) async {
      print("mainthread start : $message");
      if (message is double) {
        print("Download Percentage : $message");
        _percentage.value = message;
        _progress.value = (message * 100).round().toString();

        if ((message * 100).round() == 100) {
          print("this is video page if loop");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => vediopage(filePath: videoFilePath),
                  settings: RouteSettings(arguments: {
                    'userName': userName,
                    'mobileNamuber': mobilenumber,
                    'city': city,
                    'deviceId': device_id,
                    'language': language
                  })));
        }
      } else {
        final _checkConnectivity = await _connectivity.checkConnectivity();
        if (_checkConnectivity == ConnectivityResult.none) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              var internetErrorDialog = context;
              return internalServerError(
                  internalServerErrorContext: internetErrorDialog,
                  ErrorTitle: "Internet Error",
                  description:
                      "Error on the internet Kindly verify that you are able to access the internet.",
                  ButtonText: "ok",
                  retryButton: () {
                    Navigator.of(internetErrorDialog).pop();
                  });
            },
          );
        } else {
          //Retry Dialog
          showDialog(
            context: context,
            builder: (context) {
              var internalServerErrorDialog = context;
              return internalServerError(
                internalServerErrorContext: internalServerErrorDialog,
                ErrorTitle: "Internal Server Error",
                description:
                    "An internal server problem has occurred. Please try submitting your application again.",
                ButtonText: "Re-Try",
                retryButton: () {
                  _isolate.kill();

                  Future.delayed(
                    Duration(milliseconds: 400),
                    () {
                      _downloadvideo(
                          language: language,
                          userName: userName,
                          mobilenumber: mobileNumber,
                          city: City,
                          device_id: device_Id);
                    },
                  );

                  Navigator.of(internalServerErrorDialog).pop();
                },
              );
            },
          );
        }
      }
    });
  }

  Future<bool> askExitQuestion() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Something went wrong.."),
            content: Text(" There is internal server error."),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(
                      Duration(milliseconds: 200),
                      () {
                        Navigator.pushReplacement(
                            pagecontext,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ));
                      },
                    );
                  },
                  child: Text("Back to registration"),
                ),
              )
            ],
          ),
        )) ??
        false;
  }
}

//for download app intro as per user selected language
void _downloadthread(Map<String, dynamic> message) async {
  String fileUrl = message['url'].toString();
  print("this is video url : $fileUrl");
  String downloadlocation = message['downloadlocation'].toString();

  print("this is downloadlocation url : $downloadlocation");
  SendPort _mainthreadsenderport = message['senderport'] as SendPort;
  print("Sendport");

  int downloaded = 0;
  List<List<int>> chunks = [];

  final url = Uri.parse(fileUrl);
  print("--------$url");
  var request = new http.Request('GET', url);
  var response = http.Client().send(request).timeout(Duration(seconds: 10));

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen(
      (List<int> chunk) {
        chunks.add(chunk);
        downloaded += chunk.length;
        _mainthreadsenderport.send((downloaded / r.contentLength!));
      },
      onDone: () async {
        _mainthreadsenderport.send((downloaded / r.contentLength!));
        // Save the file
        File file = new File(downloadlocation);
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        if (await file.exists()) {
          // await file.create(recursive: true);
          await file.delete(recursive: true);
          await file.create(recursive: true);
          await file.writeAsBytes(bytes, mode: FileMode.write, flush: true);
        } else {
          await file.create(recursive: true);
          await file.writeAsBytes(bytes, mode: FileMode.write, flush: true);
        }
      },
      onError: (error) {
        _mainthreadsenderport.send("$error");
      },
    );
  }, onError: (error) {
    _mainthreadsenderport.send("$error");
  });
}
