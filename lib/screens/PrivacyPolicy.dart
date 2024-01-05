import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPoliicy extends StatefulWidget {
  const PrivacyPoliicy({super.key});

  @override
  State<PrivacyPoliicy> createState() => _PrivacyPoliicyState();
}

class _PrivacyPoliicyState extends State<PrivacyPoliicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        onWebViewCreated: (controller) {
          controller.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse("https://digividya.in/privacypolicy.php")));
        },
      ),
    );
  }
}
