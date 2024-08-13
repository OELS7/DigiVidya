// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:digividya/ChatModel/ChatModel.dart';
import 'package:digividya/Services/getDirectory.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define a StatefulWidget class named ChotiMadat
class ChotiMadat extends StatefulWidget {
  // Constructor for ChotiMadat
  const ChotiMadat({super.key});

  // Override createState to create the state for ChotiMadat
  @override
  State<ChotiMadat> createState() => _ChotiMadatState();
}

// Define the state class for ChotiMadat
class _ChotiMadatState extends State<ChotiMadat> {
  // List to store chat messages
  List<dynamic> _messages = [];

  // TextEditingController for handling input field
  final TextEditingController _editingController = TextEditingController();

  // ScrollController for handling scrolling in chat
  final ScrollController _scrollController = ScrollController();

  // Instance of chatModel
  chatModel _chatmodel = chatModel();

  // Timer for periodic chat refresh
  late Timer _timer;

  // Map to store automated responses
  Map<String, String> automatedResponse = {"": ""};

  // Initialize the state
  @override
  void initState() {
    super.initState();
    // Start the timer for refreshing chat
    _timer = refreshchat();
    // Fetch initial data and get chats
    _featchData().then((_) => getChats());
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: [
          // Expanded widget to hold chat messages
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              child: RefreshIndicator(
                onRefresh: () async {
                  _messages.clear();
                  _featchData().then((_) => getChats());
                },
                color: Colors.blue,
                child: ListView.builder(
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  controller: _scrollController,
                  addAutomaticKeepAlives: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  addRepaintBoundaries: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(1),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: messageBlock(_messages[index]),
                    );
                  },
                ),
              ),
            ),
          ),
          // Container for typing message
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      spreadRadius: BorderSide.strokeAlignCenter,
                      offset: Offset(0, 0),
                      blurStyle: BlurStyle.solid),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: _editingController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type Your Messages...."),
                          maxLines: null,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _messages.add({
                              "message": {
                                "me": _editingController.text.toString(),
                              }
                            });
                            _sendQuery(
                                query: _editingController.text.toString());
                          });

                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut);

                          _editingController.clear();
                        },
                        icon: const Icon(Icons.send))
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  // Method to fetch user queries and responses
  Future<void> _featchData() async {
    // Get the application support directory
    // String dirPath = (await getApplicationSupportDirectory()).path;

        String dir = await getDirectory().getdirectory();

    File jsonFile = File("$dir/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    var userData = {"user_id": jsonData['User_Id'].toString()};

    // API call to fetch user queries and responses
    String url = "https://digividya.in/DigiVidyaAPI/api/viewQueriesOfUser";
    var response = await http.post(Uri.parse(url), body: userData);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body.toString().replaceAll("\n", " "));
      if (jsonResponse.isNotEmpty) {
        _chatmodel.setchatHistory(chatHistorymessage: jsonResponse['Queries']);
      } else {
        _timer.cancel();
      }
    } else {}
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
    _scrollController.dispose();
  }

  // Method to send user queries
  void _sendQuery({required String query}) async {
    //String dirPath = (await getApplicationSupportDirectory()).path;

        String dir = await getDirectory().getdirectory();
    File jsonFile = File("$dir/appInfo.json");
    if (jsonFile.existsSync()) {
      int userId = 0;
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      DateTime dateTime = DateTime.now();
      String queryDate = DateFormat('dd-MM-yyyy').format(dateTime);
      String queryTime = DateFormat('H:mm:ss').format(dateTime);
      String queryDateTime = "$queryDate $queryTime";
      print("Query Date Time : $queryDate $queryTime");
      setState(() {
        userId = jsonData['User_Id'];
      });

      // API call to store user queries
      String url = "https://digividya.in/DigiVidyaAPI/api/insertQueryOfUser";
      Map<String, dynamic> userData = {
        "user_id": userId.toString(),
        "user_query": query,
        "query_time": queryDateTime
      };

      var response = await http.post(Uri.parse(url), body: userData);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonResponse.isNotEmpty && jsonResponse['status']) {
          print("query inserted successfully..");
        }
      } else {}
    }
  }

  // Method to get chat messages
  void getChats() {
    setState(() {
      _messages = _chatmodel.getMessageFormat();
    });
  }

  // Widget to display a message block
  Widget messageBlock(messag) {
    List<String> listKeys = messag['message'].keys.toList();
    List<dynamic> message = messag['message'].values.toList();
    List<Widget> messagelayout = [];
    print("$listKeys >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print("$message >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    for (var messagecount = 0; messagecount < message.length; messagecount++) {
      messagelayout.add(Align(
        alignment: listKeys[messagecount] == "me"
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: listKeys[messagecount] == "me"
                  ? Color.fromARGB(500, 1, 118, 211)
                  : Color.fromARGB(500, 1, 195, 130),
              borderRadius: BorderRadius.only(
                  topLeft: listKeys[messagecount] == "me"
                      ? Radius.circular(10)
                      : Radius.circular(0),
                  topRight: listKeys[messagecount] == "me"
                      ? Radius.circular(0)
                      : Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Text(
            message[messagecount],
            textAlign: listKeys[messagecount] == "me"
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(
                fontSize: 18,
                color: listKeys[messagecount] == "me"
                    ? Colors.white
                    : Colors.white),
          ),
        ),
      ));
    }
    return Wrap(
      children: messagelayout,
    );
  }

  // Method to refresh chat periodically
  refreshchat() {
    return Timer.periodic(Duration(seconds: 10), (timer) {
      _messages.clear();
      _featchData().then((value) => getChats());
    });
  }
}
