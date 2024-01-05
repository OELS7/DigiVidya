// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
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

    print(FormatedDate);
  }

  //show modal only when user open app first time in a day
  Future<void> _showModal() async {
    Future.delayed(
      const Duration(milliseconds: 900),
      () {
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
      },
    );
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
                padding: EdgeInsets.all(10),
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
          Text("Appreciate by your friends ",
              style: TextStyle(
                  fontFamily: 'Fontmain',
                  fontSize: 20,
                  color: Color.fromRGBO(3, 45, 96, 1))),
          Container(
              //125
              height: MediaQuery.of(context).size.height * 0.185,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppreciatedBy.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    height: MediaQuery.of(context).size.height,
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
                                "${AppreciatedBy[index]}",
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
                          style: TextStyle(color: Colors.white, fontSize: 28),
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
                  fontSize: 35,
                  color: Color.fromRGBO(3, 45, 96, 1))),
          Container(
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/AppreciateByFriend-Modal.webp'))),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Text(" Your friends appreciate you.",
                style: TextStyle(
                    color: Color.fromRGBO(3, 45, 96, 1), fontSize: 20)),
          ),
          Container(
            height: 60,
            width: 200,
            margin: const EdgeInsets.all(20),
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
    List<String> contactNumbers = [];
    List<Contact> _allContact = [];

    var status = await Permission.contacts.status;
    // check user granted permission or not ?
    if (status.isGranted) {
      //fetch contact list
      _allContact = await ContactsService.getContacts();

      List<String> Filtercontacts = [];

      for (var number in _allContact) {
        number.phones!.map((e) {
          contactNumbers.add(e.value.toString());
        }).join(",");
      }

      for (var number = 0; number < contactNumbers.length; number++) {
        //Cheak number is grater or equal to 10
        if (contactNumbers[number].length >= 10) {
          //Number contain space
          if (contactNumbers[number].contains(" ")) {
            contactNumbers[number] =
                contactNumbers[number].toString().replaceAll(' ', '');
            //Cheak number grater than 10
            if (contactNumbers[number].length > 10) {
              print("Before ${contactNumbers[number]}");
              // Remove first 3 digit i.e.+91
              contactNumbers[number] = contactNumbers[number]
                  .toString()
                  .substring(3, contactNumbers[number].length);
              //Add to new list
              setState(() {
                Filtercontacts.add(contactNumbers[number]);
              });

              print("After ${contactNumbers[number]}");
            } else {
              // Add as it is to list
              setState(() {
                Filtercontacts.add(contactNumbers[number]);
              });
            }
          } else {
            // Number not contain space
            print("Number not have space");
            //Cheak number is grater 10
            if (contactNumbers[number].length > 10) {
              print("number length is greater than 10");
              //Cheak number contain +91
              if (contactNumbers[number].contains("+91")) {
                print("number contain +91 ");
                contactNumbers[number] = contactNumbers[number]
                    .substring(3, contactNumbers[number].length)
                    .toString();
                setState(() {
                  Filtercontacts.add(contactNumbers[number]);
                });
              } else {
                setState(() {
                  Filtercontacts.add(contactNumbers[number]);
                });
              }
            } else {
              // Add as it is to list
              setState(() {
                Filtercontacts.add(contactNumbers[number]);
              });
            }
          }
        }
      }

      //Removing the duplicate numbers of contact list
      for (var number = 0; number < Filtercontacts.length; number++) {
        if (filteredContactNumber.isEmpty &&
            isValidMobileNumber(Filtercontacts[number])) {
          filteredContactNumber.add(Filtercontacts[number]);
        } else {
          if (filteredContactNumber.isNotEmpty &&
              !filteredContactNumber.contains(Filtercontacts[number]) &&
              isValidMobileNumber(Filtercontacts[number])) {
            filteredContactNumber.add(Filtercontacts[number]);
          }
        }
      }
    } else {}
  }

  // Function to check if a mobile number is valid
  bool isValidMobileNumber(String mobileNumber) {
    // Regular expression for valid mobile numbers in India
    RegExp regex = RegExp(r'^[6-9]\d{9}$');

    // Check if the mobile number matches the regular expression
    return regex.hasMatch(mobileNumber);
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
        print("Connection established.....");
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonRespons.isNotEmpty) {
          print("${jsonRespons['new_friend_list']}");
          //Cheak any number add/update in contact list if found add it in list
          for (var number = 0;
              number < jsonRespons['new_friend_list'].length;
              number++) {
            friend_List.add(jsonRespons['new_friend_list'][number]);
          }
        } else {}
      } else {
        print("Connection failed ... ");
      }
    }
  }

  //
  _getContactPersonName() async {
    List<Contact> contacts = await ContactsService.getContacts();

    for (var numbers in contacts) {
      numbers.phones!.map((e) {
        for (var number = 0; number < friend_List.length; number++) {
          if (e.value.toString() == friend_List[number] &&
              !personName.contains(numbers.displayName.toString())) {
            personName.add(numbers.displayName.toString());
            print("Number do not contain +91 are in friend list ");
          }
          if (e.value.toString() == "+91${friend_List[number]}" &&
              !personName.contains(numbers.displayName.toString())) {
            personName.add(numbers.displayName.toString());
            print("Number contain +91 are in friend list ");
          }
        }
      }).join(",");
    }

    print(
        "***************************** $personName ****************************");
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
    //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchMyAppreciation";
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
        print("No friends");
      }
    } else {}
  }

  //Match number and name from contactlist and display initials of friendlist as user save their number in phone contact list
  _getFriendsname({required List<String> friendsNumber}) async {
    List<Contact> contacts = await ContactsService.getContacts();
    for (var phoneNumbers in contacts) {
      phoneNumbers.phones!.map((e) {
        for (var number = 0; number < friendsNumber.length; number++) {
          if (friendsInitials.isEmpty) {
            if (e.value.toString() == friendsNumber[number]) {
              friendsInitials.add(phoneNumbers.displayName.toString()[0]);
            }

            if (e.value.toString() == "+91${friendsNumber[number]}") {
              friendsInitials.add(phoneNumbers.displayName.toString()[0]);
            }
          } else {
            if (e.value.toString() == friendsNumber[number] &&
                !friendsInitials
                    .contains(phoneNumbers.displayName.toString()[0])) {
              friendsInitials.add(phoneNumbers.displayName.toString()[0]);
            }

            if ((e.value.toString() == friendsNumber[number] &&
                    !friendsInitials
                        .contains(phoneNumbers.displayName.toString()[0])) ||
                (e.value.toString() == "+91${friendsNumber[number]}" &&
                    !friendsInitials
                        .contains(phoneNumbers.displayName.toString()[0]))) {
              friendsInitials.add(phoneNumbers.displayName.toString()[0]);
            }
          }
        }
      }).join(",");
    }

    print(friendsInitials);
  }

  //function for send appreciation to your friend
  _sendAppreciationToFriend() async {
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    //API call for send appreciation to your friend
    // String url =
    //     "http://192.168.1.19/prachi/DigiVidyaAPI/api/insertMyAppreciationToFriends";
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
      print(
          "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ My device API Number is ${DeviceApi}");
    });
  }
}
