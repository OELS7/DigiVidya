// Import necessary Flutter packages
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Import InAppWebView package

// Define the PrivacyPoliicy widget as a StatefulWidget
class PrivacyPoliicy extends StatefulWidget {
  const PrivacyPoliicy({super.key});

  @override
  State<PrivacyPoliicy> createState() => _PrivacyPoliicyState();
}

// Define the state class for PrivacyPoliicy
class _PrivacyPoliicyState extends State<PrivacyPoliicy> {
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget
    return Scaffold(
      appBar: AppBar(), // Display an AppBar at the top of the screen
      body: InAppWebView(
        // Display an in-app web view
        onWebViewCreated: (controller) {
          // When the web view is created
          controller.loadUrl(
            urlRequest: URLRequest(
              // Load the URL for the privacy policy
              url: Uri.parse("https://digividya.in/privacypolicy.php"),
            ),
          );
        },
      ),
    );
  }
}
