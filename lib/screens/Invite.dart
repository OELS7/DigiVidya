// ignore: file_names
import 'dart:convert';
import 'dart:io';
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
  String Image_Path = "";
  String inviteImage = "";
  String ButtonText = "";
  late BannerAd _bannerAd;
  bool _isAdloades = false;
  int section = 0;
  final AdSize adSize = AdSize(height: 320, width: 100);

  @override
  void initState() {
    _loadPreferedInviteImage();
    super.initState();
    _initBannerAd();
  }

  //To load banner add
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
          onAdFailedToLoad: (Ad, Error) {
            Text("failed to load Ad");
          },
        ),
        //Request to banner ad
        request: AdRequest());

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                bottom: MediaQuery.of(context).size.height * 0.1,
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
                        whatsAppInviteImage =
                            'assets/images/HindiInvitation.webp';
                        break;
                      case "english":
                        whatsAppInviteImage =
                            'assets/images/Englishinvitation.webp';
                        break;
                      default:
                    }

                    CallSharedImage(imagePath: whatsAppInviteImage);

                    print(
                        "Banner height: ${_bannerAd.size.height.toDouble()} Banner Width : ${_bannerAd.size.width.toDouble()}");
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.3,
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
                bottom: 0.0,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                child: _isAdloades
                    ? Container(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      )
                    : SizedBox())
          ],
        ),
      ),
    );
  }

  //Function for send image
  CallSharedImage({required String imagePath}) async {
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
      await Share.shareFiles([Image_Path], text: "https://play.google.com/store/apps/details?id=com.digividya_2023");
    } catch (e) {
      print("Failed to copy image: $e");
    }
  }

  //Method for display invite image as per user selected image
  void _loadPreferedInviteImage() async {
    String userPrefredLanguage = "";
    var dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var JsonData = jsonDecode(jsonFile.readAsStringSync());
    userPrefredLanguage = JsonData['userLanguage'].toString();

    switch (userPrefredLanguage.toLowerCase().toString()) {
      case "marathi":
        setState(() {
          inviteImage = 'assets/images/marathi.webp';
          ButtonText = "आपल्या मित्रांना मदत करण्यासाठी येथे क्लिक करा";
        });
        break;
      case "hindi":
        setState(() {
          inviteImage = "assets/images/hindi.webp";
          ButtonText = "अपने प्रियजन की मदद करें";
        });
        break;
      case "english":
        setState(() {
          inviteImage = "assets/images/english.webp";
          ButtonText = "Click here to help your friend.";
        });
        break;
      default:
    }
  }
}
