// ignore_for_file: must_be_immutable
import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:digividya/screens/LoginType.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppIntroVideo2 extends StatefulWidget {
  AppIntroVideo2({super.key});

  @override
  State<AppIntroVideo2> createState() => _AppIntroVideo2State();
}

class _AppIntroVideo2State extends State<AppIntroVideo2> {
  VideoPlayerController _playerController =
      VideoPlayerController.asset('assets/AppIntroVideos/Hindi/Hindi.mp4');

  var pagecontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DeviceId = generateDevicId();
    // debugPrint("%%%%%%%%%%%%%%%%%%%% Device Id : ${DeviceId} %%%%%%%%%%%%%");
    _playerController.addListener(_videoListner);
  }

  @override
  Widget build(BuildContext context) {
    pagecontext = context;
    return Scaffold(
      body: Chewie(
          controller: ChewieController(
              videoPlayerController: _playerController,
              autoInitialize: true,
              aspectRatio: _getAspectRatio(),
              autoPlay: true)),
    );
  }

  void _videoListner() {
    // Get the total duration of the video
    Duration totalDuration = _playerController.value.duration;
    // Get the current position of the video
    Duration position = _playerController.value.position;

    if (position == totalDuration) {
      Navigator.pushReplacement(
          pagecontext,
          MaterialPageRoute(
            builder: (context) => loginType(),
          ));
    }
  }
  
  double _getAspectRatio() {
    return (MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height);
  }

    // Function to generate random device ID
  String generateDevicId() {
    String stringPattern = "+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789!@#%^&*()"; // Define pattern for random string
    Random random = Random(); // Create a Random object
    return String.fromCharCodes(Iterable.generate(
      50, // Generate a string of length 50
      (_) => stringPattern.codeUnitAt(random.nextInt(stringPattern.length)), // Pick random character from pattern
    ));
  }
}
