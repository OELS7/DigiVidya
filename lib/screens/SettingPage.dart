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
          child: Stack(
        children: [
          Positioned(
              child: Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                DropdownButton<String>(
                    hint: Text("CHANGE YOUR LANGUAGE",
                        style: TextStyle(fontSize: 18)),
                    iconSize: 35,
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: const Color.fromRGBO(242, 242, 242, 1),
                    items: <String>['Marathi', 'Hindi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 25),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!.toString();
                      });
                      Changelanguage().then((bool value) {
                        if (value) {
                          Restart.restartApp();
                        } else {}
                      });
                    }),
                SizedBox(
                  height: 210,
                ),
              ],
            ),
          )),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.44,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/ChangeLanguage.webp"),
                      fit: BoxFit.fill)),
            ),
          ),
        ],
      )),
    );
  }

  //For change language
  Future<bool> Changelanguage() async {
    String dirpath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirpath/appInfo.json");
    //API call to update user language
    // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateLanguage";
    String url = "https://digividya.in/DigiVidyaAPI/api/updateLanguage";

    //Check json file is exist or not?
    if (jsonFile.existsSync()) {
      var jsonData = jsonDecode(jsonFile.readAsStringSync());

      //Fetch userID & userlanguage
      var userId = jsonData['User_Id'];
      jsonData['userLanguage'] = dropdownValue.toString();
      print(dropdownValue);

      var userData = {
        "user_id": userId.toString(),
        "language": dropdownValue.toString()
      };

      var response = await http.post(Uri.parse(url), body: userData);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("/n", ""));
        //Check json response is empty or not?
        if (jsonResponse.isNotEmpty && jsonResponse['status']) {
          //Delete directory of json file
          Directory("$dirpath/Digividya/").deleteSync(recursive: true);
          jsonData['userLanguage'] = dropdownValue.toString();
          jsonData['sectionAudioFileName'] = [];
          jsonData['topicAudioFileName'] = [];
          jsonData['subTopicAudio'] = [];
          jsonData['section_id'] = "";
          jsonData['topic_id'] = "";
          jsonData['subTopic_id'] = "";

          jsonFile.writeAsStringSync(jsonEncode(jsonData));

          print("Updated language: $jsonResponse");
          print("Selected Language : ${dropdownValue.toString()}");
          return true;
        } else {}
      } else {}
    } else {}
    //If not sucessfully change language
    return false;
  }
}
