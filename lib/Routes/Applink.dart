import 'package:app_links/app_links.dart'; // Importing necessary package
import 'package:flutter/services.dart'; // Importing necessary package
// Define a class named `Applink` to handle app links
class Applink {
  bool isApplinkAvail = false; // Flag to indicate if app link is available
   // Map to store query parameters from the app link
  Map<String, String> _arguments = {}; 
  String _path = ""; // String to store the path of the app link

  // Method to handle incoming app links
  ApplinkHandling() async {
    AppLinks _applinks = AppLinks(); // Creating an instance of AppLinks

    try {
      // Get initial app link
      final initialApplink = await _applinks.getInitialAppLink(); // Get initial app link

      // Checking if initial app link path is not empty
      if (initialApplink?.path != null) {
        print("The initial Applink ${initialApplink?.path.isEmpty}");

        // Handling different paths of the app link
        if (initialApplink?.path.toString() == "/") {
          isApplinkAvail = true; // Set flag to indicate app link availability
          _arguments = initialApplink!.queryParameters; // Store query parameters
          _path = initialApplink.path.toString(); // Store path of the app link
          print("%%%%%%% The Home Page Query Parameters : ${initialApplink.queryParameters} %%%%%%%%%%");
        }

        if (initialApplink?.path.toString() == "/topicpage.php") {
          // Set flag to indicate app link availability
          isApplinkAvail = true;
           // Store query parameters
          _arguments = initialApplink!.queryParameters;
          // Store path of the app link
          _path = initialApplink.path.toString();
          print("%%%%%%% The Topic Page Query Parameters : ${initialApplink.queryParameters} %%%%%%%%%%");
        }

        if (initialApplink?.path.toString() == "/subtopicpage.php") {
           // Set flag to indicate app link availability
          isApplinkAvail = true;
            // Store query parameters
          _arguments = initialApplink!.queryParameters;
          // Store path of the app link
          _path = initialApplink.path.toString();
          print("%%%%%%% The SubTopic Page Query Parameters : ${initialApplink.queryParameters} %%%%%%%%%%");
        }
      }
      // Listen to app link stream for changes
      _applinks.uriLinkStream.listen((event) {});
    } on PlatformException catch (e) {
      // Handle platform exception
      print(e.message);
    }
  }

  // Method to check if app link is available
  bool ApplinkAvail() {
    return isApplinkAvail;
  }

  // Method to get query parameters of the app link
  Map<String, String> getarguments() {
    return _arguments;
  }

  // Method to get the path of the app link
  String getPath() {
    return _path;
  }
}
