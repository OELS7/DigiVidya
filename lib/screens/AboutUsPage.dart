import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //Open webview
      body: InAppWebView(
        onWebViewCreated: (controller) {
          controller.loadUrl(
              //url parsing of about app
              urlRequest: URLRequest(url: Uri.parse("https://digividya.in")));
        },
      ),
    );
  }
}
