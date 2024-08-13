import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digividya/Services/getDirectory.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import "package:flutter/services.dart";

// Define a stateful widget named bannerad
class bannerad extends StatefulWidget {
  const bannerad({super.key});

  @override
  State<bannerad> createState() =>
      _banneradState(); // Create state for bannerad
}

// Define the state for bannerad
class _banneradState extends State<bannerad> {
  String Image_Path = ""; // Variable to store image path
  String inviteImage = ""; // Variable to store invite image path
  String ButtonText = ""; // Variable to store button text
  final AdSize adSize = AdSize(height: 320, width: 100); // Define ad size
  late BannerAd _bannerAd; // Variable to store banner ad instance
  bool _isAdloades = false; // Variable to track if ad is loaded
  bool _isFullScreenAddLoad =
      false; // Variable to track if full screen ad is loaded

// Variables for tracking section and topics
  int section = 0, topic = 0, topicCount = 0, subTopic = 0;
  late InterstitialAd
      _interstitialAd; // Variable to store interstitial ad instance
  var pagecontext; // Variable to store the current page context

  @override
  void initState() {
    super.initState(); // Call the initState of the superclass

    _initBannerAd(); // Initialize banner ad

    _loadPreferedInviteImage(); // Load preferred invite image

    _initAd(); // Load preferred invite image
  }

  // To load banner ad
  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner, // Set the ad size
        // adunitID provided by google ad mob
        adUnitId:
            "ca-app-pub-9496792246201951/5308899556", // Set the ad unit ID
        listener: BannerAdListener(
          onAdLoaded: (Ad) {
            setState(() {
              _isAdloades = true; // Set the ad loaded flag to true
            });
          },
          // Check if ad failed to load
          onAdFailedToLoad: (Ad, Error) {
            _bannerAd.request; // Request a new ad
          },
        ),
        // Request to banner ad
        request: AdRequest());

    _bannerAd.load(); // Load the banner ad
  }

  // Initialize interstitial ad
  void _initAd() {
    InterstitialAd.load(
        adUnitId:
            "ca-app-pub-9496792246201951/8266235382", // Set the ad unit ID
        request: AdRequest(), // Create an ad request
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: _onAdloaded, // Set callback for ad loaded
          onAdFailedToLoad: (Error) {
            setState(() {
              _isFullScreenAddLoad =
                  true; // Set the full screen ad loaded flag to true
            });
          },
        ));
    return;
  }

  // Full Screen Ad method to display
  void _onAdloaded(InterstitialAd ad) {
    _interstitialAd = ad; // Store the loaded interstitial ad

    // To show full screen ad
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        print("Ad is dismiss");

        Future.delayed(
          Duration(milliseconds: 600), // Delay to show the ad
          () {
            Navigator.pushReplacementNamed(pagecontext, '/subTopicPage',
                arguments: {
                  "section": section,
                  "topic": topic,
                  "topicCount": topicCount,
                  "subTopicCount": subTopic
                }); // Navigate to subTopicPage with arguments
          },
        );
        // To dispose full screen ad
        _interstitialAd.dispose();
      },
      // On failed show error
      onAdFailedToShowFullScreenContent: (ad, error) {
        setState(() {
          _isFullScreenAddLoad =
              true; // Set the full screen ad loaded flag to true
        });
      },
    );
  }

  // Override the build method
  @override
  Widget build(BuildContext context) {
    // Extract route arguments or set default empty map
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;
    // Assign values from arguments to variables
    section = arguments['section']; // Set the section
    topic = arguments['topic']; // Set the topic
    subTopic = arguments['subTopicCount']; // Set the sub topic count
    topicCount = arguments['topicCount']; // Set the topic count

    pagecontext = context; // Store the current context

    // Return the Scaffold widget with SafeArea and Stack as children
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        // Background container with decoration image
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(inviteImage) // Set the invite image
                  ,
                  fit: BoxFit.fill // Set the image fit
                  )),
          height: MediaQuery.of(context).size.height *
              1, // Set the container height
          width:
              MediaQuery.of(context).size.width * 1, // Set the container width
        ),
        // Positioned widget for button container at the bottom
        Positioned(
            bottom: MediaQuery.of(context).size.height *
                0.128, // Set bottom position
            left: MediaQuery.of(context).size.width * 0.1, // Set left position
            right:
                MediaQuery.of(context).size.width * 0.1, // Set right position
            child: GestureDetector(
              // Handle onTap event for button
              onTap: () async {
                String userPrefredLanguage =
                    ""; // Variable to store user preferred language
                String whatsAppInviteImage =
                    ""; // Variable to store WhatsApp invite image path
                var dirPath = await getDirectory().getdirectory(); // Get application support directory path

                File jsonFile =
                    File("$dirPath/appInfo.json"); // Create a file instance
                var JsonData = jsonDecode(jsonFile
                    .readAsStringSync()); // Read and decode JSON data from file
                userPrefredLanguage = JsonData[
                    'userLanguage']; // Get user language from JSON data

                // Switch statement to set WhatsApp invitation image path based on user language
                switch (userPrefredLanguage.toString().toLowerCase()) {
                  case "marathi":
                    whatsAppInviteImage =
                        'assets/images/MarathiInvitation.webp'; // Set Marathi invitation image path
                    break;
                  case "hindi":
                    whatsAppInviteImage =
                        'assets/images/HindiInvitation.webp'; // Set Hindi invitation image path
                    break;
                  case "english":
                    whatsAppInviteImage =
                        'assets/images/Englishinvitation.webp'; // Set English invitation image path
                    break;
                  default:
                }

                CallSharedImg(
                    imagePath:
                        whatsAppInviteImage); // Call function to share image

                print(
                    "Banner height: ${_bannerAd.size.height.toDouble()} Banner Width : ${_bannerAd.size.width.toDouble()}");
              },
              // Button container with gradient background
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.05, // Set button height
                width:
                    MediaQuery.of(context).size.width * 0.3, // Set button width
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white), // Set border color
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            30), // Set border radius for top right corner
                        topLeft: Radius.circular(
                            30), // Set border radius for top left corner
                        bottomRight: Radius.circular(
                            30), // Set border radius for bottom right corner
                        bottomLeft: Radius.circular(
                            30) // Set border radius for bottom left corner
                        ),
                    gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 37, 67),
                          const Color.fromARGB(255, 2, 64, 115),
                          const Color.fromARGB(255, 32, 104, 163)
                        ],
                        begin: Alignment
                            .centerRight, // Set gradient start position
                        end: Alignment.centerLeft // Set gradient end position
                        )),
                // Button text with white color and font size
                child: Center(
                  child: Text(
                    ButtonText, // Set button text
                    style: TextStyle(
                        color: Colors.white, fontSize: 15), // Set text style
                    textAlign: TextAlign.center, // Set text alignment
                  ),
                ),
              ),
            )),
        // Positioned widget for "Skip for now" text button
        Positioned(
            top: MediaQuery.of(context).size.height * 0.665, // Set top position
            left: MediaQuery.of(context).size.width * 0.3, // Set left position
            right:
                MediaQuery.of(context).size.width * 0.3, // Set right position
            bottom: MediaQuery.of(context).size.height *
                0.02, // Set bottom position
            child: TextButton(
                onPressed: () {
                  // Check if full screen ad is not loaded, then show interstitial ad, else navigate to subTopicPage
                  !_isFullScreenAddLoad
                      ? _interstitialAd.show() // Show interstitial ad
                      : Navigator.pushReplacementNamed(pagecontext,
                          '/subTopicPage', // Navigate to subTopicPage
                          arguments: {
                              "section": section,
                              "topic": topic,
                              "topicCount": topicCount,
                              "subTopicCount": subTopic
                            });
                },
                // Text for "Skip for now" button with specified style
                child: Text(
                  "Skip for now", // Set button text
                  style: TextStyle(
                    color: Colors.white, // Set text color
                    fontSize: 18.0, // Set font size
                    decorationStyle:
                        TextDecorationStyle.solid, // Set decoration style
                    fontWeight: FontWeight.bold, // Set font weight
                    decorationThickness: 5.0,
                  ),
                ))),
        // Positioned widget to place the ad container at the bottom of the screen
        Positioned(
            bottom: 0.0, // Align the widget to the bottom of the screen
            left: MediaQuery.of(context).size.width *
                0.02, // Set left margin using a percentage of screen width
            right: MediaQuery.of(context).size.width *
                0.02, // Set right margin using a percentage of screen width
            child: _isAdloades // Check if the ad is loaded
                ? Container(
                    // Container to hold the ad widget
                    height: _bannerAd.size.height
                        .toDouble(), // Set the height of the container to the ad height
                    width: _bannerAd.size.width
                        .toDouble(), // Set the width of the container to the ad width
                    child: AdWidget(
                        ad: _bannerAd), // Display the ad using AdWidget
                  )
                : SizedBox() // If ad is not loaded, display an empty SizedBox
            )
      ],
    )));
  }

  // Function for sending an image file via a sharing mechanism
  CallSharedImg({required String imagePath}) async {
    late File image; // Declare a variable to hold the image file

    Directory temDir =
        await getTemporaryDirectory(); // Get the temporary directory path
    var temPath = temDir.path; // Store the temporary directory path

    String FileName = DateTime.now()
        .microsecondsSinceEpoch
        .toString(); // Generate a unique file name using the current timestamp

    try {
      ByteData imageData = await rootBundle
          .load(imagePath); // Load the image data from the specified path
      image = File(
          '${temPath}/${FileName}.png'); // Create a File object with the temporary directory and generated file name
      image.writeAsBytesSync(
          imageData.buffer.asUint8List()); // Write the image data to the file
      // Update Image_Path with the copied image path
      Image_Path = image.path;
      // Update Image_Path with the path of the copied image
      // ignore: deprecated_member_use
      await Share.shareFiles([Image_Path],
          text:
              "https://play.google.com/store/apps/details?id=com.digividya_2023");
    } catch (e) {
      print("Failed to copy image: $e");
    }
  }

  // Method to load the preferred invite image based on the user's selected language
  _loadPreferedInviteImage() async {
    String userPrefredLanguage =
        ""; // Variable to store the user's preferred language
    var dirPath = await getDirectory().getdirectory(); // Get the path of the application support directory

    File jsonFile = File(
        "$dirPath/appInfo.json"); // Create a File object for the JSON file containing user preferences
    var JsonData = jsonDecode(jsonFile
        .readAsStringSync()); // Read and decode the JSON data from the file
    userPrefredLanguage = JsonData[
        'userLanguage']; // Retrieve the user's preferred language from the decoded JSON data

    // Switch statement to set the invite image and button text based on the user's preferred language
    switch (userPrefredLanguage.toLowerCase().toString()) {
      case "marathi":
        setState(() {
          // Set the invite image and button text for Marathi language
          inviteImage = 'assets/images/marathi.webp';
          ButtonText = "आपल्या मित्रांना मदत करण्यासाठी येथे क्लिक करा";
        });
        break;
      case "hindi":
        setState(() {
          // Set the invite image and button text for Hindi language
          inviteImage = "assets/images/hindi.webp";
          ButtonText = "अपने दोस्तों की मदद करने के लिए यहाँ क्लिक करें";
        });
        break;
      case "english":
        setState(() {
          // Set the invite image and button text for English language
          inviteImage = "assets/images/english.webp";
          ButtonText = "Click here to help your friends";
        });
        break;
      default:
    }
  }

  // Override method to dispose resources when the widget is removed from the tree
  @override
  void dispose() {
    super
        .dispose(); // Call the superclass's dispose method to ensure proper disposal
    _interstitialAd
        .dispose(); // Dispose the interstitial ad to release resources
  }
}
