// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:digividya/Services/getDirectory.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import "package:flutter/services.dart";

class Invite extends StatefulWidget {
  const Invite({super.key});

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
// Variable to store image path
  String Image_Path = "";

// Variable to store invite image path
  String inviteImage = "";

// Variable to store button text
  String ButtonText = "";

// Banner ad object
  late BannerAd _bannerAd;

// Flag to indicate if ad is loaded
  bool _isAdloades = false;

// Section number (purpose not specified in the given code)
  int section = 0;

// Ad size for banner ad
  final AdSize adSize = AdSize(height: 320, width: 100);

  @override
  void initState() {
    // Load preferred invite image
    _loadPreferedInviteImage();
    super.initState();
    // Initialize banner ad
    _initBannerAd();
  }

// To load banner ad
  void _initBannerAd() {
    // Create a BannerAd object with specified size and ad unit ID
    _bannerAd = BannerAd(
        size: AdSize.banner,
        // adUnitId provided by Google AdMob
        adUnitId: "ca-app-pub-9496792246201951/5308899556",
        // Listener to handle ad events
        listener: BannerAdListener(
          onAdLoaded: (Ad) {
            // Set state to indicate ad has loaded
            setState(() {
              _isAdloades = true;
            });
          },
          onAdFailedToLoad: (Ad, Error) {
            // Show text indicating ad failed to load
            Text("failed to load Ad");
          },
        ),
        // Request to load banner ad
        request: AdRequest());

    // Load the banner ad
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    // Return the main scaffold widget
    return Scaffold(
      // Set the background color to transparent
      backgroundColor: Colors.transparent,
      // Use SafeArea to avoid system UI intrusions
      body: SafeArea(
        // Use a Stack to overlay widgets
        child: Stack(
          children: [
            // Background container with image
            Container(
              // Set decoration with background image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(inviteImage), // Set the background image
                  fit: BoxFit.fill, // Fill the container with the image
                ),
              ),
              // Set the height and width to fill the screen
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
            ),
            // Positioned widget for the button
            Positioned(
              // Position the button at the bottom with some padding
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: GestureDetector(
                // Handle tap event
                onTap: () async {
                  // Initialize variables for user language and invite image path
                  String userPrefredLanguage = "";
                  String whatsAppInviteImage = "";
                  // Get the application support directory path
                  //var dirPath = (await getApplicationSupportDirectory()).path;

                  String dir = await getDirectory().getdirectory();

                  // Read the JSON file containing user data
                  File jsonFile = File("$dir/appInfo.json");
                  var JsonData = jsonDecode(jsonFile.readAsStringSync());
                  // Get the user's preferred language from the JSON data
                  userPrefredLanguage = JsonData['userLanguage'];

                  // Set the WhatsApp invitation image path based on the user's preferred language
                  switch (userPrefredLanguage.toString().toLowerCase()) {
                    case "marathi":
                      whatsAppInviteImage =
                          'assets/images/MarathiInvitation.webp';
                      break;
                    case "hindi":
                      whatsAppInviteImage =
                          'assets/images/HindiInvitation.webp';
                      break;
                    case "english":
                      whatsAppInviteImage =
                          'assets/images/Englishinvitation.webp';
                      break;
                    default:
                  }

                  // Call the function to share the image
                  CallSharedImage(imagePath: whatsAppInviteImage);

                  // Print the banner ad dimensions
                  print(
                    "Banner height: ${_bannerAd.size.height.toDouble()} Banner Width : ${_bannerAd.size.width.toDouble()}",
                  );
                },
                // Container for the button
                child: Container(
                  // Set the height and width of the button
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.3,
                  // Set the decoration for the button
                  decoration: BoxDecoration(
                    // Set the border with white color
                    border: Border.all(color: Colors.white),
                    // Set the border radius for rounded corners
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    // Set the gradient background for the button
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 37, 67),
                        const Color.fromARGB(255, 2, 64, 115),
                        const Color.fromARGB(255, 32, 104, 163),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  // Center the text inside the button
                  child: Center(
                    child: Text(
                      ButtonText, // Set the button text
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // Positioned widget for the banner ad
            Positioned(
              bottom: 0.0, // Position at the bottom of the screen
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              // Check if the ad is loaded
              child: _isAdloades
                  ? Container(
                      // Set the height and width of the ad container
                      height: _bannerAd.size.height.toDouble(),
                      width: _bannerAd.size.width.toDouble(),
                      // Display the ad using AdWidget
                      child: AdWidget(ad: _bannerAd),
                    )
                  : SizedBox(), // Display an empty box if the ad is not loaded
            ),
          ],
        ),
      ),
    );
  }

// Function for sending an image
  CallSharedImage({required String imagePath}) async {
    late File image; // Declare a variable to hold the image file

    // Get the temporary directory path
    Directory temDir = await getTemporaryDirectory();
    var temPath = temDir.path; // Store the temporary directory path

    // Generate a unique filename using the current timestamp
    String FileName = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      // Load the image data from the asset bundle
      ByteData imageData = await rootBundle.load(imagePath);
      // Create a new file in the temporary directory
      image = File('${temPath}/${FileName}.png');
      // Write the image data to the file
      image.writeAsBytesSync(imageData.buffer.asUint8List());
      // Update Image_Path with the copied image path
      Image_Path = image.path;
      // Share the image file with a predefined text message
      // ignore: deprecated_member_use
      await Share.shareFiles([Image_Path],
          text:
              "https://play.google.com/store/apps/details?id=com.digividya_2023");
    } catch (e) {
      // Print an error message if the image copying fails
      print("Failed to copy image: $e");
    }
  }

// Method for displaying invite image as per user selected language
  void _loadPreferedInviteImage() async {
    String userPrefredLanguage =
        ""; // Declare a variable to hold the user's preferred language
    // var dirPath = (await getApplicationSupportDirectory())
    //     .path; 
    // Get the path to the application support directory

    String dir = await getDirectory().getdirectory();

    File jsonFile = File(
        "$dir/appInfo.json"); // Create a file object for the appInfo.json file in the support directory
    var JsonData = jsonDecode(jsonFile
        .readAsStringSync()); // Read and decode the JSON data from the file
    userPrefredLanguage = JsonData['userLanguage']
        .toString(); // Extract the userLanguage from the JSON data

    // Switch case to set the invite image and button text based on the user's preferred language
    switch (userPrefredLanguage.toLowerCase().toString()) {
      case "marathi": // If the preferred language is Marathi
        setState(() {
          inviteImage =
              'assets/images/marathi.webp'; // Set the invite image to Marathi version
          ButtonText =
              "आपल्या मित्रांना मदत करण्यासाठी येथे क्लिक करा"; // Set the button text to Marathi
        });
        break;
      case "hindi": // If the preferred language is Hindi
        setState(() {
          inviteImage =
              "assets/images/hindi.webp"; // Set the invite image to Hindi version
          ButtonText =
              "अपने प्रियजन की मदद करें"; // Set the button text to Hindi
        });
        break;
      case "english": // If the preferred language is English
        setState(() {
          inviteImage =
              "assets/images/english.webp"; // Set the invite image to English version
          ButtonText =
              "Click here to help your friend."; // Set the button text to English
        });
        break;
      default: // Default case if the language does not match any case
    }
  }
}
