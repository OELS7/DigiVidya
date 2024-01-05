// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:digividya/ChatModel/ChatModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChotiMadat extends StatefulWidget {
  const ChotiMadat({super.key});

  @override
  State<ChotiMadat> createState() => _ChotiMadatState();
}

class _ChotiMadatState extends State<ChotiMadat> {
  List<dynamic> _messages = [];
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  chatModel _chatmodel = chatModel();
  late Timer _timer;
  Map<String, String> automatedResponse = {"": ""};

  @override
  void initState() {
    super.initState();
    _timer = refreshchat();
    _featchData().then((_) => getChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: [
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
                //create list for message
                child: ListView.builder(
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  controller: _scrollController,
                  addAutomaticKeepAlives: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
          //container for type message
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

  //Method to fetch queries and response
  Future<void> _featchData() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    var userData = {"user_id": jsonData['User_Id'].toString()};

    //API call for user queries and response
    // String url =
    //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/viewQueriesOfUser";
    String url = "https://digividya.in/DigiVidyaAPI/api/viewQueriesOfUser";

    var response = await http.post(Uri.parse(url), body: userData);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body.toString().replaceAll("\n", " "));
      if (jsonResponse.isNotEmpty) {
        //print(jsonResponse['Queries']);

        _chatmodel.setchatHistory(chatHistorymessage: jsonResponse['Queries']);
      } else {
        _timer.cancel();
      }
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
    _scrollController.dispose();
  }

  //Method to store user queries
  void _sendQuery({required String query}) async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
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
      //API call for store user queries
      // String url =
      //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/insertQueryOfUser";
      String url = "https://digividya.in/DigiVidyaAPI/api/insertQueryOfUser";

      Map<String, dynamic> userData = {
        "user_id": userId.toString(),
        "userquery": query,
        "query_time": queryDateTime
      };

      var response = await http.post(Uri.parse(url), body: userData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonResponse.isNotEmpty && jsonResponse['status']) {
          print("query inserted successfull..");
        }
      } else {}
    }
  }

  void getChats() {
    setState(() {
      _messages = _chatmodel.getMessageFormat();
    });
  }

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

  //For refresh chats
  refreshchat() {
    return Timer.periodic(Duration(seconds: 10), (timer) {
      _messages.clear();

      _featchData().then((value) => getChats());
    });
  }
}
