// Import necessary Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Define the AboutUsPage as a StatefulWidget
class AboutUsPage extends StatefulWidget {
  // Constructor for AboutUsPage with a key
  const AboutUsPage({super.key});

  // Create the state for AboutUsPage
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

// Define the state class for AboutUsPage
class _AboutUsPageState extends State<AboutUsPage> {
  // Override the build method to define the UI
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget to provide a structure for the page
    return Scaffold(
      // Define the AppBar for the page
      appBar: AppBar(),
      // Define the body of the Scaffold to contain an InAppWebView
      body: InAppWebView(
        // Callback when the web view is created
        onWebViewCreated: (controller) {
          // Load the URL in the web view
          controller.loadUrl(
              // Define the URL request to load the "About Us" page
              urlRequest: URLRequest(url: Uri.parse("https://digividya.in")));
        },
      ),
    );
  }
}
