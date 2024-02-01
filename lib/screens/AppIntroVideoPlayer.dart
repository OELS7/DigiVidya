// import 'dart:io';
// import 'package:chewie/chewie.dart';
// import 'package:digividya/screens/free_time.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// // ignore: must_be_immutable
// class vediopage extends StatefulWidget {
//   String filePath;
//   vediopage({super.key, required this.filePath});

//   @override
//   State<vediopage> createState() => _vediopageState(filePath);
// }

// class _vediopageState extends State<vediopage> {
//   late VideoPlayerController _playerController;
//   late ChewieController _chewieController;
//   String videoFilePath;
//   String userName = "",
//       mobilenumber = "",
//       city = "",
//       device_id = "",
//       language = "";

//   _vediopageState(this.videoFilePath);

//   @override
//   void initState() {
//     _playerController = VideoPlayerController.file(File(videoFilePath));
//     _chewieController = ChewieController(
//         videoPlayerController: _playerController,
//         autoInitialize: true,
//         allowFullScreen: true,
//         showControlsOnInitialize: true,
//         autoPlay: true,
//         materialProgressColors: ChewieProgressColors(playedColor: Colors.blue),
//         aspectRatio: 763 / 1640);

//     _playerController.addListener(_videoListner);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var arguments = (ModalRoute.of(context)!.settings.arguments ??
//         <String, String>{}) as Map;
//     userName = arguments['userName'];
//     mobilenumber = arguments['mobileNamuber'];
//     city = arguments['city'];
//     device_id = arguments['deviceId'];
//     language = arguments['language'];
//     return Scaffold(
//         body: SafeArea(
//             child: WillPopScope(
//                 onWillPop: _onBackPressed,
//                 child: Chewie(controller: _chewieController))));
//   }

//   /// ExitDialog Box
//   ///
//   /// This Function show the Dialog Box to get the confirmation from the user to exit the page. if the User click on yes application get close or if user click on No the user stay on this page.
//   Future<bool> _onBackPressed() async {
//     return (await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                   title: Text("Leave page"),
//                   content: Text("Are you want to leave this page"),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         exit(0);
//                       },
//                       child: Text("Yes"),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("No"))
//                   ],
//                 ))) ??
//         false;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _playerController.dispose();
//     _chewieController.dispose();
//   }

//   /// Video Listener
//   ///
//   /// This method track the progress of video and opent the next screen which is free time where user selecte the convient time.
//   void _videoListner() {
//     Duration totalDuration = _playerController.value.duration;
//     Duration position = _playerController.value.position;

//     if (totalDuration == position) {
//       File(videoFilePath).deleteSync(recursive: true);
//       _playerController.removeListener(_videoListner);
//       //initilize after 300 miliseconds
//       Future.delayed(
//         Duration(milliseconds: 300),
//         () {
//           //navigate to covenient time screen
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => freetime(),
//                   settings: RouteSettings(arguments: {
//                     //taking all this information of user
//                     'userName': userName,
//                     'mobileNo': mobilenumber,
//                     'city': city,
//                     'device_id': device_id,
//                     'language': language
//                   })));
//         },
//       );
//     }
//   }
// }
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:digividya/screens/free_time.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class vediopage extends StatefulWidget {
  // String filePath;
    String userName = "",
      mobilenumber = "",
      city = "",
      device_id = "",
      language = "";
  vediopage({super.key,required this.userName,required this.mobilenumber,required this.language,required this.city ,required this.device_id});

  @override
  State<vediopage> createState() => _vediopageState(userName: userName,mobilenumber: mobilenumber,city: city,device_id: device_id,language: language);
}

class _vediopageState extends State<vediopage> {
  late VideoPlayerController _playerController;
  late ChewieController _chewieController;
  String userName = "",
      mobilenumber = "",
      city = "",
      device_id = "",
      language = "";

  _vediopageState({required this.userName,required this.mobilenumber,required this.language,required this.city,required this.device_id});

  @override
  void initState() {
    //.contentUri(Uri.file(videoFilePath))
      _playerController = VideoPlayerController.asset('assets/AppIntroVideos/$language/$language.mp4');
      _chewieController = ChewieController(
          videoPlayerController: _playerController,
          autoInitialize: true,
          allowFullScreen: true,
          showControlsOnInitialize: true,
          autoPlay: true,
          materialProgressColors:
              ChewieProgressColors(playedColor: Colors.blue),
          aspectRatio: 763 / 1640);
    

    _playerController.addListener(_videoListner);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
            child: WillPopScope(
                onWillPop: _onBackPressed,
                child: Chewie(controller: _chewieController))));
  }

  /// ExitDialog Box
  ///
  /// This Function show the Dialog Box to get the confirmation from the user to exit the page. if the User click on yes application get close or if user click on No the user stay on this page.
  Future<bool> _onBackPressed() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Leave page"),
                  content: Text("Are you want to leave this page"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text("Yes"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No"))
                  ],
                ))) ??
        false;
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
    _chewieController.dispose();
  }

  /// Video Listener
  ///
  /// This method track the progress of video and opent the next screen which is free time where user selecte the convient time.
  void _videoListner() {
    Duration totalDuration = _playerController.value.duration;
    Duration position = _playerController.value.position;

    if (totalDuration == position) {
      // File(videoFilePath).deleteSync(recursive: true);
      _playerController.removeListener(_videoListner);
      //initilize after 300 miliseconds
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          //navigate to covenient time screen
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => freetime(),
                  settings: RouteSettings(arguments: {
                    //taking all this information of user
                    'userName': userName,
                    'mobileNo': mobilenumber,
                    'city': city,
                    'device_id': device_id,
                    'language': language
                  })));
        },
      );
    }
  }
}
