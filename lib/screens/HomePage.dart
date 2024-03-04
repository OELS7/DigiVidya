// ignore_for_file: deprecated_member_use

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
import 'package:permission_handler/permission_handler.dart';
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
  int selectedIndex = 0;
  late bgAudioPlayer player;
  int DeviceApi = 0;
  bool like = false, DisLike = false;
  Connectivity _connectivity = Connectivity();
  CarouselController _carouselController = CarouselController();
  ValueNotifier<bool> Like = ValueNotifier<bool>(false);
  ValueNotifier<bool> Dislike = ValueNotifier<bool>(false);
  int currentIndex = 0;
  var isprofileuploaded = true;
  String contactno = "";
  String FormatedDate = "";
  String GuestName = "";
  String Guest_id = "";
  List<String> personName = [];
  List<String> friend_List = [];
  List<String> filteredContactNumber = [];
  List<String> AppreciatedBy = [];
  List<String> friendsInitials = [];
  Map<String, String> phoneContactNumber = {};
  late Isolate isolate;

  @override
  void initState() {
    super.initState();
    getDeviceAPI();
    WidgetsBinding.instance.addObserver(this);
    _Checconnectivity();
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    return Future.delayed(
      Duration.zero,
      () {
        print("**************** Page pop **********");
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        (ModalRoute.of(context)?.settings.arguments ?? <String, int>{}) as Map;
    GuestName = argument.isNotEmpty ? argument["guestName"] : "";
    Guest_id = argument.isNotEmpty ? argument["User_id"] : "";
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              var dialogBox = context;
              return exitAppDialog(dialogcontect: dialogBox);
            },
          );
        }
      },
      child: Scaffold(
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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

  selectedWidget(int selectedIndex) {
    List<Widget> widgets = [fragmentFrame(), ChotiMadat(), Invite()];
    return IndexedStack(
      index: selectedIndex,
      children: widgets,
    );
  }

  // To take user last open app date
  Future<void> showAlert() async {
    SharedPreferences dalyNotification = await SharedPreferences.getInstance();
    DateTime date = DateTime.now();
    FormatedDate = DateFormat('dd-MM-yyyy').format(date);

    if (dalyNotification.getString("Last open date") == FormatedDate) {
      // show Nothing
     
    } else {
      // show Dialog Box
      dalyNotification.setString("Last open date", FormatedDate);
       _fetchContact().then((_) {
        _getFriendsList().then((_) {
          _getContactPersonName().then((_) {
            _getAppreciation().then((_) {
              _getFriendsname(friendsNumber: AppreciatedBy).then((_) {
                _showModal();
              });
            });
          });
        });
      });
    }

    //print(FormatedDate);
  }

  //show modal only when user open app first time in a day
  Future<void> _showModal() async {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (context) {
          return CarouselSlider(
            items: [
              // to call function of appreciated by user friends
              topicAppreciatedBy(),
              // to call function appreciate to your friend
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
                aspectRatio: 16 / 9),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    player.disposeAudio();
  }

  //Function for appreciate to your friend
  topicVideoViewBy() {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Appreciate to your friends",
              style: TextStyle(
                  fontFamily: 'Fontmain',
                  fontSize: 20,
                  color: const Color.fromRGBO(1, 118, 211, 1))),
          Container(
              height: MediaQuery.of(context).size.height * 0.185,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: personName.length,
                padding: EdgeInsets.all(8),
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
                          backgroundColor: const Color.fromRGBO(1, 118, 211, 1),
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
          Container(
            padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
            child: Text(
                " You can also appreciate your friends for better digital skills.",
                style: TextStyle(
                    color: const Color.fromRGBO(1, 118, 211, 1), fontSize: 20)),
          ),
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
      )),
    );
  }

  // to call function of appreciated by user friends
  topicAppreciatedBy() {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Appreciated by your friends ",
              style: TextStyle(
                  fontFamily: 'Fontmain',
                  fontSize: 20,
                  color: Color.fromRGBO(3, 45, 96, 1))),
          Container(
              //125
              height: MediaQuery.of(context).size.height * 0.185,
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
                    padding: EdgeInsets.all(8),
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
                              backgroundColor: Color.fromRGBO(3, 45, 96, 1),
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
                          AppreciatedBy[index] == friend_List[index] ? personName[index] : "U",
                          style: TextStyle(color: Colors.black, fontSize: 15),
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
          Container(
            padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
            child: Text(" Your friends appreciate you.",
                style: TextStyle(
                    color: Color.fromRGBO(3, 45, 96, 1), fontSize: 20)),
          ),
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
      )),
    );
  }

  //To fetch contact list of user
  _fetchContact() async {
    List<Contact> _allContact = [];

    var status = await Permission.contacts.status;
    // check user granted permission or not ?
    if (status.isGranted) {
      //fetch contact list
      _allContact = await ContactsService.getContacts();

      // ReceivePort _MainthreadReciverPort = ReceivePort();

      // await Isolate.spawn(processContact, {
      //   "senderPort": _MainthreadReciverPort.sendPort,
      //   "ContactsObject": _allContact
      // });

      // _MainthreadReciverPort.listen(
      //   (message) {
      //     // if (filteredContactNumber.contains(message[1].toString())) {
      //     //   phoneContactNumber[message[0].toString()] = message[0].toString();
      //     //   filteredContactNumber.add(message[1].toString());
      //     // }

      //     if (message is List) {
      //       var mycontact = message as List<String>;

      //       if (mycontact.isNotEmpty) {
      //         phoneContactNumber[mycontact[0].toString()] =
      //             mycontact[1].toString();
      //         filteredContactNumber.add(mycontact[1].toString());
      //         // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      //        // print(phoneContactNumber);
      //         // print(filteredContactNumber);
      //       } else {}

      //       // print("this is List of String");
      //       // print(" $mycontact ");
      //     } else {
      //       print("this is another");
      //     }

      //     //   int i=1;
      //     // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ${i++}: $message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      //   },
      // );

      // _getFriendsList();

      // Future.delayed(Duration(microseconds: 60));

      List<Future<void>> future = [];
      for (Contact _contact in _allContact) {
        future.add(_processContact(_contact));
      }

      await Future.wait(future);

      //print("%%%%%%%%%%%%%%%%%% $filteredContactNumber %%%%%%%%%%%%%%%%%");
    } else {}
  }

  //For Friendlist
  _getFriendsList() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");

    if (jsonFile.existsSync()) {
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      //API call for friendlist
      // String url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateFriends";
      String url = "https://digividya.in/DigiVidyaAPI/api/updateFriends";

      print(
          "%%%%%%%%%%%%%%%%%%%%%%% ${filteredContactNumber} %%%%%%%%%%%%%%%%%%%%%%");

      var userData = {
        "user_id": jsonData['User_Id'].toString(),
        "contact_list": filteredContactNumber
            .toString()
            .split("[")
            .last
            .split("]")
            .first
            .toString()
            .replaceAll(", ", ","),
        "app_opened_date": FormatedDate
      };

      var response = await http.post(Uri.parse(url), body: userData);
      if (response.statusCode == 200) {
        print("Connection");
        print("Connection established.....");
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonRespons.isNotEmpty) {
          print(
              "%%%%%%%%%%%%%%%%%%%%%%%% Response Receive : ${jsonRespons['new_friend_list']} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          //Cheak any number add/update in contact list if found add it in list
          for (var number = 0;
              number < jsonRespons['new_friend_list'].length;
              number++) {
            friend_List.add(jsonRespons['new_friend_list'][number]);
          }
        }
      } else {
        print("Connection failed ... ");
      }
    }
  }

  // Finding the friends name that matches with my contact`
  _getContactPersonName() async {
    List<Future<void>> _personName = [];

    friend_List.forEach((element) {
      _personName.add(_getFriendsName(element));
    });

    await Future.wait(_personName);
  }

  //For back button
  Future<bool> _OnBackButtonPress() {
    return Future.delayed(
      Duration.zero,
      () {
        setState(() {
          selectedIndex = 0;
        });

        return false;
      },
    );
  }

  //Function for display which friends appreciate you
  _getAppreciation() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    //API Call for which friends appreciate you
    // String url =
    // "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchMyAppreciation";
    String url = "https://digividya.in/DigiVidyaAPI/api/fetchMyAppreciation";

    File JsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(JsonFile.readAsStringSync());
    String userId = jsonData['User_Id'].toString();

    var userData = {"user_id": userId};

    var response = await http.post(Uri.parse(url), body: userData);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRespons =
          jsonDecode(response.body.toString().replaceAll("\n", " "));
      List<dynamic> myAppreciation = jsonRespons['new_friend_list'];

      //Check any one appreciate or not
      if (myAppreciation.isNotEmpty) {
        for (var number = 0; number < myAppreciation.length; number++) {
          AppreciatedBy.add(myAppreciation[number].toString());
        }
        print(jsonRespons['new_friend_list']);
      } else {
        AppreciatedBy = [];
        print("No friends");
      }
    } else {}
  }

  //Match number and name from contactlist and display initials of friendlist as user save their number in phone contact list
  _getFriendsname({required List<String> friendsNumber}) async {
    List<Future<void>> _getInitial = [];

    friendsNumber.forEach((element) {
      _getInitial.add(createFirendsInitialsList(element));
    });

    await Future.wait(_getInitial);

    // List<Contact> contacts = await ContactsService.getContacts();
    // for (var phoneNumbers in contacts) {
    //   phoneNumbers.phones!.map((e) {
    //     for (var number = 0; number < friendsNumber.length; number++) {
    //       if (friendsInitials.isEmpty) {
    //         if (e.value.toString() == friendsNumber[number]) {
    //           friendsInitials.add(phoneNumbers.displayName.toString()[0]);
    //         }

    //         if (e.value.toString() == "+91${friendsNumber[number]}") {
    //           friendsInitials.add(phoneNumbers.displayName.toString()[0]);
    //         }
    //       } else {
    //         if (e.value.toString() == friendsNumber[number] &&
    //             !friendsInitials
    //                 .contains(phoneNumbers.displayName.toString()[0])) {
    //           friendsInitials.add(phoneNumbers.displayName.toString()[0]);
    //         }

    //         if ((e.value.toString() == friendsNumber[number] &&
    //                 !friendsInitials
    //                     .contains(phoneNumbers.displayName.toString()[0])) ||
    //             (e.value.toString() == "+91${friendsNumber[number]}" &&
    //                 !friendsInitials
    //                     .contains(phoneNumbers.displayName.toString()[0]))) {
    //           friendsInitials.add(phoneNumbers.displayName.toString()[0]);
    //         }
    //       }
    //     }
    //   }).join(",");
    // }

    // print(friendsInitials);
  }

  //function for send appreciation to your friend
  _sendAppreciationToFriend() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    //API call for send appreciation to your friend
    // String url =
    // "http://192.168.1.19/prachi/DigiVidyaAPI/api/insertMyAppreciationToFriends";
    String url =
        "https://digividya.in/DigiVidyaAPI/api/insertMyAppreciationToFriends";

    String userID = jsonData['User_Id'].toString(), appOpenDate = FormatedDate;
    var userData = {"user_id": userID, "app_opened_date": appOpenDate};

    var response = await http.post(Uri.parse(url), body: userData);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRespons =
          jsonDecode(response.body.toString().replaceAll("\n", " "));

      if (jsonRespons['status']) {
        print("Appreciation Send to Friends...");
      }
    } else {}
  }

  //function for check internet connectivity
  void _Checconnectivity() async {
    final _checkConnectivity = await _connectivity.checkConnectivity();
    if (_checkConnectivity == ConnectivityResult.none) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Please check your internet connectivity ",
          );
        },
      );
    } else {
      showAlert();
    }
  }

  void getDeviceAPI() async {
    final AndroidDeviceInfo androidDeviceInfo =
        await DeviceInfoPlugin().androidInfo;
    setState(() {
      DeviceApi = androidDeviceInfo.version.sdkInt;
      // print(
      //     "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ My device API Number is ${DeviceApi}");
    });
  }

  Future<void> _processContact(Contact contact) async {
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
          phoneContactNumber[contact.displayName!] = formattedNumber;
          filteredContactNumber.add(formattedNumber);
        }
      }
    }
  }

  Future<void> _getFriendsName(String element) async {
    phoneContactNumber.forEach((key, value) {
      if (value == element) {
        personName.add(key.toString());
      }
    });
  }

  Future<void> createFirendsInitialsList(String element) async {
    phoneContactNumber.forEach((key, value) {
      if (value == element) {
        friendsInitials.add(key.toString()[0]);
      }
    });
  }
}

void processContact(Map<String, dynamic> message) {
  var contacts = message["ContactsObject"] as List<Contact>;
  SendPort senderPort = message["senderPort"] as SendPort;
  List<String> personContact = []; // Initialize inside the loop

  for (Contact _contact in contacts) {
    if (_contact.phones != null) {
      for (Item phone in _contact.phones!) {
        // Format phone number
        PhoneNumber phoneNumber = PhoneNumber.parse(phone.value.toString(),
            callerCountry: IsoCode.IN);

        String formattedNumber = phoneNumber.international.toString();

        // Remove country code and store 10-digit numbers
        if (formattedNumber.length == 13) {
          formattedNumber = formattedNumber.substring(3); // Remove country code
          if (formattedNumber.length == 10) {
            // Initialize inside the loop to avoid reusing the same object
            // personContact = ["", ""];
            personContact.add(_contact.displayName!.toString());
            personContact.add(formattedNumber.toString());
            // print(
            //     "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $personContact %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            Future.delayed(Duration(milliseconds: 10));
            senderPort.send(personContact);
            personContact.clear();
          }
        }
      }
    }
  }
}
