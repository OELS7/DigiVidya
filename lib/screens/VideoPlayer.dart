import 'package:digividya/widgets/videoWidget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable

class videoPlayer extends StatefulWidget {
  videoPlayer({
    super.key,
  });

  @override
  State<videoPlayer> createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: videoWidget(
          VideoFile: arguments['filePath'],
          minutes: arguments['minutes'],
          seconds: arguments['seconds'],
          section: arguments['section'],
          topicNumber: arguments['topic'],
          topicCount: arguments['topicCount'],
          subTopicNumber: arguments['subTopic'],
          subTopicCount: arguments['subTopicCount'],
          itemPointer: arguments['itemPointer'],
          contentUrls: arguments['contentUrls'],
          FileName: arguments['FileName'],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
