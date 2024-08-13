import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class downloadProgress extends StatelessWidget {
  ValueNotifier<double> progress; 
  var downloadErrorContext ;


//required this.downloadDialogContext
  downloadProgress({super.key, required this.progress, required this.downloadErrorContext});

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
          height: MediaQuery.sizeOf(context).height * 0.5,
          width: MediaQuery.sizeOf(context).width * 0.06,
          decoration: BoxDecoration(
              // color: Colors.green,
              image: DecorationImage(
                  image: AssetImage(
                      "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
          child: ValueListenableBuilder(
            valueListenable: progress,
            builder: (context, value, child) {
              _checkDownloadCompleted(value);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.blue,
                    // height: MediaQuery.sizeOf(context).height * 0.05,
                    child: LottieBuilder.asset(
                      "assets/Animation/download.json",
                      fit: BoxFit.cover,
                      repeat: true,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                  SizedBox(
                    child: Text(
                      "Downloading...",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.75,
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: value,
                      color: Colors.blue,
                    ),
                  ),
                   SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                ],
              );
            },
          ),
        ));
  }
  
  void _checkDownloadCompleted(double value) {
    if(value == 1.0){
      Navigator.pop(downloadErrorContext,true);
      
    }
  }

}
