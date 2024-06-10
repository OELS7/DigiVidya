import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  String dropdownValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: // This Stack widget is used to overlay multiple widgets on top of each other.
Stack(
  children: [
    // Positioned widget is used to position its child widget relative to its parent.
    Positioned(
      // This widget centers its child vertically and horizontally within its parent.
      child: Center(
        child: Column(
          children: [
            // SizedBox widget creates a box with a specified height.
            SizedBox(height: 100),
            // DropdownButton widget creates a dropdown button for selecting options.
            DropdownButton<String>(
              // Text displayed when no option is selected.
              hint: Text("CHANGE YOUR LANGUAGE", style: TextStyle(fontSize: 18)),
              // Size of the dropdown button icon.
              iconSize: 35,
              // BorderRadius of the dropdown button.
              borderRadius: BorderRadius.circular(15),
              // Background color of the dropdown.
              dropdownColor: const Color.fromRGBO(242, 242, 242, 1),
              // List of dropdown items.
              items: <String>['Marathi', 'Hindi']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  // Value of the dropdown item.
                  value: value,
                  // Child widget displayed in the dropdown.
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }).toList(),
              // Callback function called when a dropdown item is selected.
              onChanged: (String? newValue) {
                setState(() {
                  // Update the selected dropdown value.
                  dropdownValue = newValue!.toString();
                });
                // Call a function to change the language.
                Changelanguage().then((bool value) {
                  if (value) {
                    // Restart the app if language change is successful.
                    Restart.restartApp();
                  } else {
                    // Handle failure to change language.
                  }
                });
              },
            ),
            SizedBox(
              height: 210,
            ),
          ],
        ),
      ),
    ),
    Positioned(
      // Position the container at the bottom of the stack.
      bottom: 0.0,
      child: Container(
        // Set the height of the container to 44% of the screen height.
        height: MediaQuery.of(context).size.height * 0.44,
        // Set the width of the container to match the screen width.
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // Display an image as the background of the container.
          image: DecorationImage(
            // Load the image from the specified asset path.
            image: AssetImage("assets/images/ChangeLanguage.webp"),
            // Adjust the image to fill the entire container.
            fit: BoxFit.fill,
          ),
        ),
      ),
    ),
  ],)
)
    );
  }

// Function to change the language setting of the app
Future<bool> Changelanguage() async {
  // Get the directory path for storing application data
  String dirpath = (await getApplicationSupportDirectory()).path;
  // Create a File object for the JSON file storing user information
  File jsonFile = File("$dirpath/appInfo.json");
  // Define the URL for the API endpoint to update user language
  String url = "https://digividya.in/DigiVidyaAPI/api/updateLanguage";

  // Check if the JSON file exists
  if (jsonFile.existsSync()) {
    // Read the contents of the JSON file and decode it
    var jsonData = jsonDecode(jsonFile.readAsStringSync());

    // Fetch the user ID and selected language from the JSON data
    var userId = jsonData['User_Id'];
    jsonData['userLanguage'] = dropdownValue.toString();
    print(dropdownValue);

    // Create a map containing user ID and selected language
    var userData = {
      "user_id": userId.toString(),
      "language": dropdownValue.toString()
    };

    // Send a POST request to the API endpoint with user data
    var response = await http.post(Uri.parse(url), body: userData);
    if (response.statusCode == 200) {
      // Decode the response body and remove newline characters
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body.toString().replaceAll("/n", ""));
      // Check if the response is not empty and contains a 'status' field
      if (jsonResponse.isNotEmpty && jsonResponse['status']) {
        // Update the language setting in the JSON data
        jsonData['userLanguage'] = dropdownValue.toString();
        // Clear additional fields related to audio files and topic IDs
        jsonData['sectionAudioFileName'] = [];
        jsonData['topicAudioFileName'] = [];
        jsonData['subTopicAudio'] = [];
        jsonData['section_id'] = "";
        jsonData['topic_id'] = "";
        jsonData['subTopic_id'] = "";

        // Write the updated JSON data back to the file
        jsonFile.writeAsStringSync(jsonEncode(jsonData));

        // Print debug information
        print("Updated language: $jsonResponse");
        print("Selected Language : ${dropdownValue.toString()}");
        // Return true to indicate successful language change
        return true;
      } else {
        // Handle empty or invalid response
      }
    } else {
      // Handle HTTP error
    }
  } else {
    // Handle JSON file not found
  }
  // Return false if language change was unsuccessful
  return false;
}

}
