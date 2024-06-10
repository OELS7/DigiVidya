// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digividya/BgService/bgAudioPlayer.dart';
import 'package:digividya/screens/ChotiMadat.dart';
import 'package:digividya/screens/Invite.dart';
import 'package:digividya/screens/Profile2.dart';
import 'package:digividya/screens/FragmentFrame.dart';
import 'package:digividya/widgets/ExitAppDialog.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> with WidgetsBindingObserver {
// Integer variable to store the index of the selected item
int selectedIndex = 0;
// Background audio player instance
late bgAudioPlayer player;
// Integer variable to store device API
int DeviceApi = 0;
// Boolean variables for like and dislike states
bool like = false, DisLike = false;
// Connectivity instance for network connectivity
Connectivity _connectivity = Connectivity();
// Carousel controller for controlling the carousel widget
CarouselController _carouselController = CarouselController();
// Value notifier for Like state
ValueNotifier<bool> Like = ValueNotifier<bool>(false);
// Value notifier for Dislike state
ValueNotifier<bool> Dislike = ValueNotifier<bool>(false);
// Value notifier for friends appreciation state
ValueNotifier<bool> friendsAppriciation = ValueNotifier<bool>(false);
// Value notifier for friends name state
ValueNotifier<bool> friendsName = ValueNotifier<bool>(false);
// Value notifier for loading friends
ValueNotifier<bool> LoadingFrient = ValueNotifier(false);
// Value notifier for refreshing list
ValueNotifier<bool> refreshList = ValueNotifier(false);
// Integer variable to store current index
int currentIndex = 0;
// Boolean variable to store profile upload status
var isprofileuploaded = true;
// String variable to store contact number
String contactno = "";
// String variable to store formatted date
String FormatedDate = "";
// String variable to store guest name
String GuestName = "";
// String variable to store guest id
String Guest_id = "";
// List to store person names
List<String> personName = [];
// List to store friend list
List<String> friend_List = [];
// List to store filtered contact numbers
List<String> filteredContactNumber = [];
// List to store appreciated by
List<String> AppreciatedBy = [];
// List to store friends initials
List<String> friendsInitials = [];
// List to store friends numbers from server
List<String> friendsNumberFromServer = [];
// Map to store phone contact numbers
Map<String, dynamic> phoneContactNumber = {};
// Isolate instance for isolating code
late Isolate isolate;
// Stopwatch for measuring time
Stopwatch stopwatch = Stopwatch();
// SharedPreferences instance for storing data
late SharedPreferences _sharedPreferences;


// Override method to initialize the state of the widget
@override
void initState() {
  // Call the superclass initState method
  super.initState();
  // Call the method to get the device API
  getDeviceAPI();
  // Add observer to listen for widget lifecycle changes
  WidgetsBinding.instance.addObserver(this);
  // Check the connectivity status
  _Checconnectivity();
}


  // @override
  // Future<bool> didPopRoute() {
  //   // TODO: implement didPopRoute
  //   return Future.delayed(
  //     Duration.zero,
  //     () {
  //       // print("**************** Page pop **********");
  //       return false;
  //     },
  //   );
  // }

// Override method to build the widget
@override
Widget build(BuildContext context) {
  // Get the arguments passed to the widget
  final argument =
      (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;
  // Extract guest name and ID from the arguments
  GuestName = argument.isNotEmpty ? argument["guestName"] : "";
  Guest_id = argument.isNotEmpty ? argument["User_id"] : "";
  // Return a widget wrapped in a PopScope to handle navigation pop events
  return PopScope(
    // Disable popping the widget
    canPop: false,
    // Define action when pop is invoked
    onPopInvoked: (didPop) {
      // Check if selectedIndex is not 0
      if (selectedIndex != 0) {
        setState(() {
          selectedIndex = 0;
        });
      } else {
        // Show dialog to confirm app exit
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var dialogBox = context;
            return exitAppDialog(dialogcontect: dialogBox);
          },
        );
      }
    },
    child: Scaffold(
      // Define end drawer
      endDrawer: const Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55),
                bottomLeft: Radius.circular(55))),
        child: Profile2(),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 35.0,
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Image.asset("assets/app_log/DigiVidyaLogo.webp"),
        ),
        title: const Center(
          child: Text(
            "DigiVidya",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color.fromRGBO(3, 45, 96, 1),
            const Color.fromRGBO(1, 118, 211, 1),
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
        ),
      ),
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: selectedWidget(selectedIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
              if (selectedIndex == 0) {}
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.help), label: "Choti Madat"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add), label: "Invite")
          ]),
    ),
  );
}


// Define a function to return the selected widget based on the selected index
selectedWidget(int selectedIndex) {
  // Define a list of widgets
  List<Widget> widgets = [fragmentFrame(), ChotiMadat(), Invite()];
  // Return an IndexedStack widget to manage the visibility of widgets
  return IndexedStack(
    // Set the index to show the selected widget
    index: selectedIndex,
    // Define the list of widgets as children of the IndexedStack
    children: widgets,
  );
}


//=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  // To take user last open app date
// Define a function to show the alert
Future<void> showAlert() async {
  // Get the SharedPreferences instance for daily notifications
  SharedPreferences dalyNotification = await SharedPreferences.getInstance();
  // Initialize the SharedPreferences instance
  _sharedPreferences = await SharedPreferences.getInstance();
  // Get the current date and format it
  DateTime date = DateTime.now();
  FormatedDate = DateFormat('dd-MM-yyyy').format(date);

  // Get the processed contact list from SharedPreferences
  var contactList = await _sharedPreferences.getString("processedContact");
  // Decode the JSON string to a Map
  phoneContactNumber = jsonDecode(contactList ?? "{}");

  // Initialize lists
  friend_List = await _sharedPreferences.getStringList("friendsNumber") ?? [];
  personName = [];
  AppreciatedBy = await _sharedPreferences.getStringList("UserAppreciation") ?? [];

  // Loop through phoneContactNumber to find friends
  phoneContactNumber.forEach((key, value) {
    friend_List.forEach((element) {
      if (value == element) {
        print("Result : ${value.toString()}, ${element}");
        personName.add(key.toString());
      }
    });
  });

  // Print lists for debugging
  print("The Users Contact List: $phoneContactNumber");
  print("The Users Friends Contact List: $friend_List");
  print("The Users Appreciation List: $AppreciatedBy");

  // Check if personName list is not empty
  if (personName.length != 0) {
    // Check if the last open date is the same as the current date
    if (dalyNotification.getString("Last open date") == FormatedDate) {
      // Do nothing if the last open date is the same as the current date
    } else {
      // Show the dialog box if the last open date is different
      dalyNotification.setString("Last open date", FormatedDate);
      _showModal();
      LoadingFrient.value = true;
      friendsAppriciation.value = true;
      friendsName.value = true;
    }
  } else {
    print("Person Name list is Empty");
  }
}


// Define a function to show the modal only when the user opens the app for the first time in a day
Future<void> _showModal() async {
  // Show a modal bottom sheet
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    isDismissible: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) {
      // Return a CarouselSlider with two items
      return CarouselSlider(
        items: [
          // Call the function to display topics appreciated by user friends
          topicAppreciatedBy(),
          // Call the function to appreciate your friend's video view
          topicVideoViewBy(),
        ],
        carouselController: _carouselController,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.9,
          autoPlay: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          initialPage: 0,
          scrollDirection: Axis.horizontal,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
          aspectRatio: 16 / 9,
        ),
      );
    },
  );
}


// Override the dispose method to clean up resources
@override
void dispose() {
  super.dispose();
  // Remove the observer for widget bindings
  WidgetsBinding.instance.removeObserver(this);
  // Dispose the audio player
  player.disposeAudio();
}


  //Function for appreciate to your friend
  topicVideoViewBy() {
    return Scaffold(
        body: SafeArea(
      child: ValueListenableBuilder(
        valueListenable: friendsName,
        builder: (context, value, child) {
          if (value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Appreciate to your friends",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 20,
                        color: const Color.fromRGBO(1, 118, 211, 1))),
                Container(
                    height: MediaQuery.of(context).size.height * 0.235,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: personName.length,
                      padding: EdgeInsets.all(7),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 120,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    const Color.fromRGBO(1, 118, 211, 1),
                                child: CircleAvatar(
                                  radius: 37,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundColor:
                                        const Color.fromRGBO(1, 118, 211, 1),
                                    child: Center(
                                        child: Text(
                                      "${personName[index][0]}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 28),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                personName[index],
                                softWrap: false,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        );
                      },
                    )),
                Divider(
                  color: Colors.blue,
                ),
                Text("EXCELLENT WORK !!",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 28,
                        color: const Color.fromRGBO(1, 118, 211, 1))),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/AppreciateToFriend-Modal.webp'))),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
                //   child: Text(
                //       " You can also appreciate your friends for better digital skills.",
                //       style: TextStyle(
                //           color: const Color.fromRGBO(1, 118, 211, 1),
                //           fontSize: 20)),
                // ),
                Container(
                  height: 55,
                  width: 185,
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _sendAppreciationToFriend().then((_) {
                        Navigator.pop(context, false);
                      });
                    },
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/AppreciateToFriend-Button.webp'),
                                fit: BoxFit.fill)),
                        child: Center(
                          child: Text(
                            'Appreciate',
                            style: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Appreciate to your friends",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 20,
                        color: const Color.fromRGBO(1, 118, 211, 1))),
                Container(
                    height: MediaQuery.of(context).size.height * 0.235,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ValueListenableBuilder(
                      valueListenable: refreshList,
                      builder: (context, value, child) {
                        if (value) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: personName.length,
                            padding: EdgeInsets.all(7),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          const Color.fromRGBO(1, 118, 211, 1),
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 33,
                                          backgroundColor: const Color.fromRGBO(
                                              1, 118, 211, 1),
                                          child: Center(
                                              child: Text(
                                            "${personName[index][0]}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28),
                                          )),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      personName[index],
                                      softWrap: false,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return IconButton(
                              onPressed: () async {
                                var contactList = await _sharedPreferences
                                    .getString("processedContact");

                                phoneContactNumber =
                                    jsonDecode(contactList ?? "{}");

                                print(
                                    "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Contact List : $phoneContactNumber %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

                                friend_List = await _sharedPreferences
                                        .getStringList("friendsNumber") ??
                                    [];

                                phoneContactNumber.forEach(
                                  (key, value) {
                                    friend_List.forEach(
                                      (element) {
                                        if (value == element) {
                                          print(
                                              "Result : ${value.toString()}, ${element}");
                                          personName.add(key.toString());
                                        }
                                      },
                                    );
                                  },
                                );

                                print(
                                    "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Friends Contact List : $friend_List %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

                                AppreciatedBy = await _sharedPreferences
                                        .getStringList("UserAppreciation") ??
                                    [];

                                print(
                                    "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Appreciation List : $AppreciatedBy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

                                LoadingFrient.value = true;
                                friendsAppriciation.value = true;
                                friendsName.value = true;
                                refreshList.value = true;
                              },
                              icon: Icon(Icons.refresh));
                        }
                      },
                    )),
                Divider(
                  color: Colors.blue,
                ),
                Text("EXCELLENT WORK !!",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 28,
                        color: const Color.fromRGBO(1, 118, 211, 1))),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/AppreciateToFriend-Modal.webp'))),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
                //   child: Text(
                //       " You can also appreciate your friends for better digital skills.",
                //       style: TextStyle(
                //           color: const Color.fromRGBO(1, 118, 211, 1),
                //           fontSize: 20)),
                // ),
                Container(
                  height: 55,
                  width: 185,
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _sendAppreciationToFriend().then((_) {
                        Navigator.pop(context, false);
                      });
                    },
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/AppreciateToFriend-Button.webp'),
                                fit: BoxFit.fill)),
                        child: Center(
                          child: Text(
                            'Appreciate',
                            style: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    ));
  }

  // to call function of appreciated by user friends
  topicAppreciatedBy() {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: friendsAppriciation,
        builder: (context, value, child) {
          if (value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Appreciated by your friends ",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 20,
                        color: Color.fromRGBO(3, 45, 96, 1))),
                Container(
                    //125
                    height: MediaQuery.of(context).size.height * 0.235,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ValueListenableBuilder(
                      valueListenable: LoadingFrient,
                      builder: (context, value, child) {
                        if (value) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: AppreciatedBy.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120,
                                height: MediaQuery.of(context).size.height,
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Color.fromRGBO(3, 45, 96, 1),
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 33,
                                          backgroundColor:
                                              Color.fromRGBO(3, 45, 96, 1),
                                          child: Center(
                                              child: Text(
                                            "${AppreciatedBy[index] == friend_List[index] ? personName[index][0] : "U"}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28),
                                          )),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      AppreciatedBy[index] == friend_List[index]
                                          ? personName[index]
                                          : "U",
                                      softWrap: false,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return AppreciatedBy.length == 0
                              ? Center(
                                  child: Text("You have no frients yet."),
                                )
                              : Center(
                                  child: Text("please wait while Loading...."),
                                );
                        }
                      },
                    )),
                Divider(
                  color: Color.fromRGBO(3, 45, 96, 1),
                ),
                Text("WELL DONE !!",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 28,
                        color: Color.fromRGBO(3, 45, 96, 1))),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/AppreciateByFriend-Modal.webp'))),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
                //   child: Text(" Your friends appreciate you.",
                //       style: TextStyle(
                //           color: Color.fromRGBO(3, 45, 96, 1), fontSize: 20)),
                // ),
                Container(
                  height: 55,
                  width: 185,
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _carouselController.nextPage(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // color: Color.fromRGBO(3, 45, 96, 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/AppreciateByFriend-Button.webp'),
                              fit: BoxFit.fill)),
                      child: Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Fontmain',
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Appreciated by your friends ",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 20,
                        color: Color.fromRGBO(3, 45, 96, 1))),
                Container(
                    //125
                    height: MediaQuery.of(context).size.height * 0.235,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppreciatedBy.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 120,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.all(7),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Color.fromRGBO(3, 45, 96, 1),
                                child: CircleAvatar(
                                  radius: 37,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundColor:
                                        Color.fromRGBO(3, 45, 96, 1),
                                    child: Center(
                                        child: Text(
                                      "${AppreciatedBy[index] == friend_List[index] ? personName[index][0] : "U"}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 28),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                AppreciatedBy[index] == friend_List[index]
                                    ? personName[index]
                                    : "U",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )
                            ],
                          ),
                        );
                      },
                    )),
                Divider(
                  color: Color.fromRGBO(3, 45, 96, 1),
                ),
                Text("WELL DONE !!",
                    style: TextStyle(
                        fontFamily: 'Fontmain',
                        fontSize: 28,
                        color: Color.fromRGBO(3, 45, 96, 1))),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/AppreciateByFriend-Modal.webp'))),
                ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
                //   child: Text(" Your friends appreciate you.",
                //       style: TextStyle(
                //           color: Color.fromRGBO(3, 45, 96, 1), fontSize: 20)),
                // ),
                Container(
                  height: 55,
                  width: 185,
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _carouselController.nextPage(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // color: Color.fromRGBO(3, 45, 96, 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/AppreciateByFriend-Button.webp'),
                              fit: BoxFit.fill)),
                      child: Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Fontmain',
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )),
    );
  }

// Function to handle back button press
Future<bool> _OnBackButtonPress() {
  return Future.delayed(
    Duration.zero,
    () {
      // Set selectedIndex to 0 when back button is pressed
      setState(() {
        selectedIndex = 0;
      });
      // Return false to prevent default back button behavior
      return false;
    },
  );
}


// Function to send appreciation to your friend
_sendAppreciationToFriend() async {
  // Get the directory path
  String dirPath = (await getApplicationSupportDirectory()).path;
  // Create a file object
  File jsonFile = File("$dirPath/appInfo.json");
  // Read JSON data from the file
  var jsonData = jsonDecode(jsonFile.readAsStringSync());

  // Define the API URL
  String url = "https://digividya.in/DigiVidyaAPI/api/insertMyAppreciationToFriends";

  // Extract user ID and app open date from JSON data
  String userID = jsonData['User_Id'].toString(), appOpenDate = FormatedDate;
  // Prepare user data for API request
  var userData = {"user_id": userID, "app_opened_date": appOpenDate};

  // Send POST request to the API endpoint
  var response = await http.post(Uri.parse(url), body: userData);

  // Check if the response status code is 200
  if (response.statusCode == 200) {
    // Decode the JSON response
    Map<String, dynamic> jsonRespons = jsonDecode(response.body.toString().replaceAll("\n", " "));

    // Check if the status in the response is true
    if (jsonRespons['status']) {
      // Print confirmation message
      print("Appreciation Sent to Friends...");
    }
  }
}


// Function to check internet connectivity
void _Checconnectivity() async {
  // Check the current connectivity status
  final _checkConnectivity = await _connectivity.checkConnectivity();
  // If there is no internet connection
  if (_checkConnectivity == ConnectivityResult.none) {
    // Show dialog informing about internet connectivity issue
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        var internetErrorContext = context;
        return InternetErrorDialog(
          internetErrorDialogContext: internetErrorContext,
          message: "Please check your internet connectivity",
        );
      },
    );
  } else {
    // If there is internet connection, show alert
    showAlert();
  }
}

// Function to get device API version
void getDeviceAPI() async {
  // Retrieve device information for Android
  final AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  // Set the device API version
  setState(() {
    DeviceApi = androidDeviceInfo.version.sdkInt;
    // Uncomment below line to print device API number
    // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ My device API Number is ${DeviceApi}");
  });
}

Future<void> _processContact(Contact contact) async {
  // Process each phone number of the contact
  for (Item phone in contact.phones!) {
    // Format phone number
    PhoneNumber phoneNumber = PhoneNumber.parse(phone.value.toString(), callerCountry: IsoCode.IN);
    String formattedNumber = phoneNumber.international.toString();

    // Remove country code and store 10-digit numbers
    if (formattedNumber.length == 13) {
      formattedNumber = formattedNumber.substring(3); // Remove country code
      if (formattedNumber.length == 10) {
        phoneContactNumber[contact.displayName!] = formattedNumber;
        filteredContactNumber.add(formattedNumber);
      }
    }
  }
}

Future<List<String>> getFriendsNumberFromServer() async {
  List<String> friendsNumber = [];
  String dirPath = (await getApplicationSupportDirectory()).path;
  File jsonFile = File("$dirPath/appInfo.json");
  DateTime date = DateTime.now();
  FormatedDate = DateFormat('dd-MM-yyyy').format(date);
  var jsonData = jsonDecode(jsonFile.readAsStringSync());
  // API URL for updating friends
  String getNumber_Url = "https://digividya.in/DigiVidyaAPI/api/updateFriends";
  var userData = {
    "user_id": jsonData['User_Id'].toString(),
    "contact_list": filteredContactNumber.toString().split("[").last.split("]").first.toString().replaceAll(", ", ","),
    "app_opened_date": FormatedDate
  };

  try {
    var response = await http.post(Uri.parse(getNumber_Url), body: userData);
    if (response.statusCode == 200) {
      print("Connection established");
      Map<String, dynamic> jsonRespons = jsonDecode(response.body.toString().replaceAll("\n", " "));
      if (jsonRespons.isNotEmpty) {
        // Check if any number has been added/updated in the contact list, then add it to the list
        for (var number = 0; number < jsonRespons['new_friend_list'].length; number++) {
          friendsNumber.add(jsonRespons['new_friend_list'][number]);
        }
      }
    } else {
      print("Connection failed ... ${response.statusCode} ");
    }
  } on HttpException catch (e) {
    print("Exception caught: ${e.message.toString()}");
  }

  return friendsNumber;
}


// Getting User Appreciation List From Server
void _getMyAppreciationList() async {
  // API URL for fetching user appreciation list
  String getappreciationList_Url = "https://digividya.in/DigiVidyaAPI/api/fetchMyAppreciation";
  String dirPath = (await getApplicationSupportDirectory()).path;
  File JsonFile = File("$dirPath/appInfo.json");
  var jsonData = jsonDecode(JsonFile.readAsStringSync());
  String userId = jsonData['User_Id'].toString();
  List<String> AppreciatedBy = [];

  try {
    var userData = {"user_id": userId};
    var response = await http.post(Uri.parse(getappreciationList_Url), body: userData);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRespons = jsonDecode(response.body.toString().replaceAll("\n", " "));
      List<dynamic> myAppreciation = jsonRespons['new_friend_list'];

      // Check if anyone has appreciated or not
      if (myAppreciation.isNotEmpty) {
        for (var number = 0; number < myAppreciation.length; number++) {
          AppreciatedBy.add(myAppreciation[number].toString());
        }
        _sharedPreferences = await SharedPreferences.getInstance();
        if (!_sharedPreferences.containsKey("UserAppreciation")) {
          _sharedPreferences.setStringList("UserAppreciation", AppreciatedBy);
        } else {
          if (_sharedPreferences.getStringList("UserAppreciation")!.isNotEmpty) {
            _sharedPreferences.setStringList("UserAppreciation", AppreciatedBy);
          } else {}
        }
      } else {
        AppreciatedBy = [];
      }
    }
  } on http.ClientException catch (e) {
    print("Exception caught: ${e.message.toString()}");
  }

  print("Friends Number who Appreciated You : ${AppreciatedBy}");
}

void prepareContact() async {
  List<Contact> _contact = await ContactsService.getContacts();
  stopwatch.start();
  print("Entering in Contact Processing Phase");
  for (var singleContact = 0; singleContact < _contact.length; singleContact++) {
    ReceivePort mainThreadReceiver = ReceivePort();
    Isolate isolate = await Isolate.spawn(filtercontact, {
      "ContactOfPerson": _contact[singleContact],
      "MainthreadPort": mainThreadReceiver.sendPort
    });
    mainThreadReceiver.listen((message) {
      phoneContactNumber[message[0].toString()] = message[1].toString();
      filteredContactNumber.add(message[1].toString());
    });

    print("%%%%%%%%%%%%%%%%%%%%%%%%%% Contact Number ${singleContact + 1} is Filtered %%%%%%%%%%%%%%%%%%%%%%%%");
  }

  print("Time Taken to filter the valid MobileNumber : ${(stopwatch.elapsedMilliseconds / 1000).toString()}");

  stopwatch.stop();
}

}

// Function for filtering contact
void filtercontact(dynamic message) async {
  Contact contact = message['ContactOfPerson'] as Contact;
  SendPort sendPort = message['MainthreadPort'] as SendPort;

  // Process each phone number of the contact
  for (Item phone in contact.phones!) {
    // Format phone number
    PhoneNumber phoneNumber =
        PhoneNumber.parse(phone.value.toString(), callerCountry: IsoCode.IN);

    String formattedNumber = phoneNumber.international.toString();

    // Remove country code and store 10-digit numbers
    if (formattedNumber.length == 13) {
      formattedNumber = formattedNumber.substring(3); // Remove country code
      if (formattedNumber.length == 10) {
        // phoneContactNumber[contact.displayName!] = formattedNumber;
        // filteredContactNumber.add(formattedNumber);
        print("thread send this Data ${[contact.displayName!, formattedNumber]}");
        sendPort.send([contact.displayName!, formattedNumber]);
      }
    }
  }
}

