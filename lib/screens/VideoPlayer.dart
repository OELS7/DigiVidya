// Import the required widget for video playback
import 'package:digividya/widgets/videoWidget.dart';
import 'package:flutter/material.dart';

// Ignore this linting rule for the StatefulWidget
// ignore: must_be_immutable

// Define a StatefulWidget named videoPlayer
class videoPlayer extends StatefulWidget {
  // Constructor for videoPlayer, accepts a key parameter
  videoPlayer({
    super.key,
  });

  @override
  // Create the state for the videoPlayer widget
  State<videoPlayer> createState() => _videoPlayerState();
}

// Define the state class for the videoPlayer widget
class _videoPlayerState extends State<videoPlayer> {
  @override
  // Initialize the state
  void initState() {
    super.initState();
  }

  @override
  // Build the widget tree
  Widget build(BuildContext context) {
    // Retrieve arguments passed to this widget via the route
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;
    
    // Return a Scaffold widget
    return Scaffold(
      // Ensure the UI is within the safe area of the device
      body: SafeArea(
        // Display the videoWidget with the provided arguments
        child: videoWidget(
          VideoFile: arguments['filePath'],        // Path to the video file
          minutes: arguments['minutes'],           // Duration in minutes
          seconds: arguments['seconds'],           // Duration in seconds
          section: arguments['section'],           // Section of the video
          topicNumber: arguments['topic'],         // Topic number
          topicCount: arguments['topicCount'],     // Total topic count
          subTopicNumber: arguments['subTopic'],   // Sub-topic number
          subTopicCount: arguments['subTopicCount'],// Total sub-topic count
          itemPointer: arguments['itemPointer'],   // Pointer to the item
          contentUrls: arguments['contentUrls'],   // Content URLs
          FileName: arguments['FileName'],         // Name of the file
        ),
      ),
    );
  }

  @override
  // Dispose of resources when the widget is removed from the widget tree
  void dispose() {
    super.dispose();
  }
}
