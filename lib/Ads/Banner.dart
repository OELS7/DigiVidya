import 'dart:convert';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import "package:flutter/services.dart";

class bannerad extends StatefulWidget {
  const bannerad({super.key});

  @override
  State<bannerad> createState() => _banneradState();
}

class _banneradState extends State<bannerad> {
  String Image_Path = "";
  String inviteImage = "";
  String ButtonText = "";
  final AdSize adSize = AdSize(height: 320, width: 100);
  late BannerAd _bannerAd;
  bool _isAdloades = false;
  bool _isFullScreenAddLoad = false;

  int section = 0, topic = 0, topicCount = 0, subTopic = 0;
  late InterstitialAd _interstitialAd;
  var pagecontext;

  @override
  void initState() {
    super.initState();

    _initBannerAd();

    _loadPreferedInviteImage();

    _initAd();
  }

  //To load banner ad
  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        // adunitID provided by google ad mob
        adUnitId: "ca-app-pub-9496792246201951/5308899556",
        listener: BannerAdListener(
          onAdLoaded: (Ad) {
            setState(() {
              _isAdloades = true;
            });
          },
          //check add fail to load or not?
          onAdFailedToLoad: (Ad, Error) {
            _bannerAd.request;
          },
        ),
        //Request to banner ad
        request: AdRequest());

    _bannerAd.load();
  }

  void _initAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-9496792246201951/8266235382",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: _onAdloaded,
          onAdFailedToLoad: (Error) {
            setState(() {
              _isFullScreenAddLoad = true;
            });
          },
        ));
    return;
  }

  // Full Screen Add method  display
  void _onAdloaded(InterstitialAd ad) {
    _interstitialAd = ad;
    //To show full screen ad

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        print("Ad is dismiss");

        Future.delayed(
          Duration(milliseconds: 600),
          () {
            Navigator.pushReplacementNamed(pagecontext, '/subTopicPage',
                arguments: {
                  "section": section,
                  "topic": topic,
                  "topicCount": topicCount,
                  "subTopicCount": subTopic
                });
          },
        );
        //To dispose full screen ad
        _interstitialAd.dispose();
      },
      //On failed show error
      onAdFailedToShowFullScreenContent: (ad, error) {
        setState(() {
          _isFullScreenAddLoad = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;
    section = arguments['section'];
    topic = arguments['topic'];
    subTopic = arguments['subTopicCount'];
    topicCount = arguments['topicCount'];

    pagecontext = context;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
      },
        child: Scaffold(
            body: SafeArea(
                child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(inviteImage), fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.63,
            bottom: MediaQuery.of(context).size.height * 0.139,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: GestureDetector(
              onTap: () async {
                String userPrefredLanguage = "";
                String whatsAppInviteImage = "";
                var dirPath = (await getApplicationSupportDirectory()).path;
                File jsonFile = File("$dirPath/appInfo.json");
                var JsonData = jsonDecode(jsonFile.readAsStringSync());
                userPrefredLanguage = JsonData['userLanguage'];

                // add whatsApp invitation image path here
                //WhatsApp invitation as per user selected language
                switch (userPrefredLanguage.toString().toLowerCase()) {
                  case "marathi":
                    whatsAppInviteImage =
                        'assets/images/MarathiInvitation.webp';
                    break;
                  case "hindi":
                    whatsAppInviteImage = 'assets/images/HindiInvitation.webp';
                    break;
                  // case "english":
                  //   whatsAppInviteImage =
                  //       'assets/images/Englishinvitation.webp';
                  //   break;
                  default:
                }

                CallSharedImg(imagePath: whatsAppInviteImage);

                // print(
                //     "Banner height: ${_bannerAd.size.height.toDouble()} Banner Width : ${_bannerAd.size.width.toDouble()}");
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 37, 67),
                          const Color.fromARGB(255, 2, 64, 115),
                          const Color.fromARGB(255, 32, 104, 163)
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft)),
                child: Center(
                  child: Text(
                    ButtonText,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.685,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.02,
            child: TextButton(
                onPressed: () {
                  !_isFullScreenAddLoad
                      ? _interstitialAd.show()
                      : Navigator.pushReplacementNamed(
                          pagecontext, '/subTopicPage',
                          arguments: {
                              "section": section,
                              "topic": topic,
                              "topicCount": topicCount,
                              "subTopicCount": subTopic
                            });
                },
                child: Text(
                  "Skip for now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    decorationStyle: TextDecorationStyle.solid,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 5.0,
                  ),
                ))),
        Positioned(
            bottom: 0.0,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: _isAdloades
                ? Container(
                    height: _bannerAd.size.height.toDouble() * 0.8,
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : SizedBox())
      ],
    ))));
  }

  //Function for send image
  CallSharedImg({required String imagePath}) async {
    late File image;

    Directory temDir = await getTemporaryDirectory();
    var temPath = temDir.path;

    String FileName = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      ByteData imageData = await rootBundle.load(imagePath);
      image = File('${temPath}/${FileName}.png');
      image.writeAsBytesSync(imageData.buffer.asUint8List());
      // Update Image_Path with the copied image path
      Image_Path = image.path;
      // ignore: deprecated_member_use
      await Share.shareFiles([Image_Path], text: "https://digividya.in");
    } catch (e) {
      print("Failed to copy image: $e");
    }
  }

  //Method for display invite image as per user selected image
  _loadPreferedInviteImage() async {
    String userPrefredLanguage = "";
    var dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var JsonData = jsonDecode(jsonFile.readAsStringSync());
    userPrefredLanguage = JsonData['userLanguage'];

    switch (userPrefredLanguage.toLowerCase().toString()) {
      case "marathi":
        setState(() {
          inviteImage = 'assets/images/marathi.webp';
          ButtonText = " मदत करण्यासाठी येथे क्लिक करा.";
        });
        break;
      case "hindi":
        setState(() {
          inviteImage = "assets/images/hindi.webp";
          ButtonText = "मदद के लिए यहां क्लिक करें.";
        });
        break;
      // case "english":
      //   setState(() {
      //     inviteImage = "assets/images/english.webp";
      //     ButtonText = "Click here to help your friends";
      //   });
      //   break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }
}
