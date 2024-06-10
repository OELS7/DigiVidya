// Define a class named `chatModel`
class chatModel {
  // A list of maps to store message blocks
  List<Map<String, dynamic>> messageBloc = [];
  // A variable to store chat history
  var chatHistory = [];
  // Method to set chat history
  void setchatHistory({required chatHistorymessage}) {
    // Set the chat history with the provided messages
    chatHistory = chatHistorymessage;
    print("After getting chat history : $chatHistory");
  }

  // Method to get the message format from chat history
  List<Map<String, dynamic>> getMessageFormat() {
    print(
        "chat history from getMessageFormat method : $chatHistory ....................");
    // Iterate through each chat history entry
    for (var chatindex = 0; chatindex < chatHistory.length; chatindex++) {
      // Check if the chat status is "Answered"
      if (chatHistory[chatindex]['DC_STATUS'] == "Answered") {
        // Add a message block with both query and answer
        messageBloc.add({
          "message": {
            "me": chatHistory[chatindex]['DC_QUERY'],
            "admin": chatHistory[chatindex]['DC_ANSWER']
          }
        });
      } else {
        // Add a message block with only the query
        messageBloc.add({
          "message": {"me": chatHistory[chatindex]['DC_QUERY']}
        });
      }
    }
    print("This from chatModel : $messageBloc ....................");
    // Return the message blocks
    return messageBloc;
  }
}
