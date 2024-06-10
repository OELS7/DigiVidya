// Import necessary packages
import 'package:chewie/chewie.dart';
import 'package:digividya/screens/free_time.dart';
import 'package:digividya/widgets/ExitAppDialog.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Define a stateful widget class named vediopage
// ignore: must_be_immutable
class vediopage extends StatefulWidget {
  // Define required fields for user information
  String userName = "",
      mobilenumber = "",
      city = "",
      device_id = "",
      language = "";

  // Constructor to initialize the vediopage widget with required parameters
  vediopage({super.key, required this.userName, required this.mobilenumber, required this.language, required this.city, required this.device_id});

  // Create the state for vediopage
  @override
  State<vediopage> createState() => _vediopageState(userName: userName, mobilenumber: mobilenumber, city: city, device_id: device_id, language: language);
}

// Define the state class for vediopage
class _vediopageState extends State<vediopage> {
  // Declare controllers for video player and Chewie
  late VideoPlayerController _playerController;
  late ChewieController _chewieController;

  // Define required fields for user information
  String userName = "",
      mobilenumber = "",
      city = "",
      device_id = "",
      language = "";

  // Constructor to initialize the state with required parameters
  _vediopageState({required this.userName, required this.mobilenumber, required this.language, required this.city, required this.device_id});

  // Override the initState method to initialize controllers
  @override
  void initState() {
    // Initialize the video player controller with the asset video file
    _playerController = VideoPlayerController.asset('assets/AppIntroVideos/$language/$language.mp4');
    
    // Initialize the Chewie controller with the video player controller
    _chewieController = ChewieController(
      videoPlayerController: _playerController,
      autoInitialize: true,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      autoPlay: true,
      materialProgressColors: ChewieProgressColors(playedColor: Colors.blue),
      aspectRatio: 763 / 1640,
    );

    // Add a listener to track the video progress
    _playerController.addListener(_videoListner);

    // Call the super class initState
    super.initState();
  }

  // Override the build method to define the UI
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget to provide a structure for the page
    return Scaffold(
      // Use SafeArea to avoid system intrusions
      body: SafeArea(
        // Use PopScope to handle back button press
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            _onBackPressed();
          },
          // Display the video using Chewie
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }

  /// Show Exit Dialog Box
  ///
  /// This Function shows the Dialog Box to get the confirmation from the user to exit the page. 
  /// If the user clicks on yes, the application closes or if the user clicks on no, the user stays on this page.
  _onBackPressed() async {
    // Show a dialog box to confirm exit
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var dialogBox = context;
        return exitAppDialog(dialogcontect: dialogBox);
      },
    );
  }

  // Override the dispose method to clean up controllers
  @override
  void dispose() {
    // Call the super class dispose
    super.dispose();
    // Dispose the video player controller
    _playerController.dispose();
    // Dispose the Chewie controller
    _chewieController.dispose();
  }

  /// Video Listener
  ///
  /// This method tracks the progress of the video and opens the next screen which is free time where the user selects the convenient time.
  void _videoListner() {
    // Get the total duration of the video
    Duration totalDuration = _playerController.value.duration;
    // Get the current position of the video
    Duration position = _playerController.value.position;

    // Check if the video has finished playing
    if (totalDuration == position) {
      // Remove the listener to stop tracking
      _playerController.removeListener(_videoListner);

      // Delay for 300 milliseconds before navigating to the next screen
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          // Navigate to the free time screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => freetime(),
              settings: RouteSettings(arguments: {
                // Pass the user information to the next screen
                'userName': userName,
                'mobileNo': mobilenumber,
                'city': city,
                'device_id': device_id,
                'language': language,
              }),
            ),
          );
        },
      );
    }
  }
}
