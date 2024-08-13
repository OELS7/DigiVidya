import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class downloadFailed extends StatefulWidget {
  var retryDownload;
  downloadFailed({super.key, required this.retryDownload});

  @override
  State<downloadFailed> createState() =>
      _downloadFailedState(retryButton: retryDownload);
}

class _downloadFailedState extends State<downloadFailed> {
  var retryButton;

  _downloadFailedState({required this.retryButton});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        minimum: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * 0.34,
            left: MediaQuery.sizeOf(context).width * 0.04,
            right: MediaQuery.sizeOf(context).width * 0.04,
            bottom: MediaQuery.sizeOf(context).height * 0.34),
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.06,
          width: MediaQuery.sizeOf(context).width * 0.05,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/App popups/Pop_up ICONS/AppExitBg.webp"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: LottieBuilder.asset(
                "assets/Animation/DownloadFailed.json",
                fit: BoxFit.cover,
                repeat: true,
                height: 100,
                width: 100,
              )),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              Container(
                child: Text(
                  "Downloading...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  softWrap: false,
                  textAlign: TextAlign.center,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              Container(
                child: Text(
                  "Please check your connection and re-start download by clicking  're-start download' button",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  softWrap: false,
                  textAlign: TextAlign.center,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              Container(
                child: ElevatedButton(
                    onPressed: retryButton, child: Text("re-start download")),
              )
            ],
          ),
        ));
  }
}
