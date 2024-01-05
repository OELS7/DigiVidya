class chatModel {
  List<Map<String, dynamic>> messageBloc = [];
  var chatHistory = [];

  void setchatHistory({required chatHistorymessage}) {
    chatHistory = chatHistorymessage;
    print("After getting chat history : $chatHistory");
  }

  List<Map<String, dynamic>> getMessageFormat() {
    print(
        "chat history from getMessageFormat method : $chatHistory ....................");
    for (var chatindex = 0; chatindex < chatHistory.length; chatindex++) {
      if (chatHistory[chatindex]['DC_STATUS'] == "Answered") {
        messageBloc.add({
          "message": {
            "me": chatHistory[chatindex]['DC_QUERY'],
            "admin": chatHistory[chatindex]['DC_ANSWER']
          }
        });
      } else {
        messageBloc.add({
          "message": {"me": chatHistory[chatindex]['DC_QUERY']}
        });
      }
    }
    print("This from chatModel : $messageBloc ....................");
    return messageBloc;
  }
}
