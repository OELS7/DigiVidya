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
  int selectedIndex = 0;
  late bgAudioPlayer player;
  int DeviceApi = 0;
  bool like = false, DisLike = false;
  Connectivity _connectivity = Connectivity();
  CarouselController _carouselController = CarouselController();
  ValueNotifier<bool> Like = ValueNotifier<bool>(false);
  ValueNotifier<bool> Dislike = ValueNotifier<bool>(false);
  ValueNotifier<bool> friendsAppriciation = ValueNotifier<bool>(false);
  ValueNotifier<bool> friendsName = ValueNotifier<bool>(false);
  ValueNotifier<bool> LoadingFrient = ValueNotifier(false);
  ValueNotifier<bool> refreshList = ValueNotifier(false);
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
  List<String> friendsNumberFromServer = [];
  Map<String, dynamic> phoneContactNumber = {};
  late Isolate isolate;
  Stopwatch stopwatch = Stopwatch();
  late SharedPreferences _sharedPreferences;

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
        // print("**************** Page pop **********");
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

//=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  // To take user last open app date
  Future<void> showAlert() async {
    SharedPreferences dalyNotification = await SharedPreferences.getInstance();
    _sharedPreferences = await SharedPreferences.getInstance();
    DateTime date = DateTime.now();
    FormatedDate = DateFormat('dd-MM-yyyy').format(date);

    var contactList = await _sharedPreferences.getString("processedContact");

    phoneContactNumber = jsonDecode(contactList ?? "{}");

    print(
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Contact List : $phoneContactNumber %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    friend_List = await _sharedPreferences.getStringList("friendsNumber") ?? [];

    phoneContactNumber.forEach(
      (key, value) {
        friend_List.forEach(
          (element) {
            if (value == element) {
              print("Result : ${value.toString()}, ${element}");
              personName.add(key.toString());
            }
          },
        );
      },
    );

    print(
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Friends Contact List : $friend_List %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    AppreciatedBy =
        await _sharedPreferences.getStringList("UserAppreciation") ?? [];

    print(
        "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Users Appreciation List : $AppreciatedBy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
//

    if (personName.length != 0) {
      if (dalyNotification.getString("Last open date") == FormatedDate) {
        // show Nothing
      } else {
        // show Dialog Box
        dalyNotification.setString("Last open date", FormatedDate);
        _showModal();
        LoadingFrient.value = true;
        friendsAppriciation.value = true;
        friendsName.value = true;
      }
    } else {
      print("Person Name list is Empty");
    }

    // dalyNotification.setString("Last open date", FormatedDate);

    // ProcessAppreciationData();
    // _showModal();

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

  // void ProcessAppreciationData() async {
  //   // _fetchContactList();

  //   prepareContact();
  // }

  // void _fetchContactList() async {
  //   _sharedPreferences = await SharedPreferences.getInstance();

  //   if (!_sharedPreferences.containsKey("processedContact")) {
  //     //In this block we fetch all the contact and fillter and formate in valide phone number
  //     List<Contact> _allContact = [];

  //     var status = await Permission.contacts.status;
  //     // check user granted permission or not ?
  //     if (status.isGranted) {
  //       //fetch contact list
  //       _allContact = await ContactsService.getContacts();

  //       List<Future<void>> future = []; // this is list of future method
  //       for (Contact _contact in _allContact) {
  //         print("Processing Contacts");
  //         future
  //             .add(_processContact(_contact)); // This is the future void method
  //       }

  //       print("waiting for result");

  //       await Future.wait(future); // This line perform paraller processing
  //       print("Contact Processing completd");

  //       print("Waiting for friends Number from Server");
  //       //getting friends number from server
  //       await getFriendsNumberFromServer().then((value) {
  //         friendsNumberFromServer = value;
  //       });

  //       print("friends Number receive");

  //       if (!_sharedPreferences.containsKey("processedContact") &&
  //           !_sharedPreferences.containsKey("friendsNumber")) {
  //         print("Inserting in Shared Preference");
  //         _sharedPreferences.setString(
  //             "processedContact", jsonEncode(phoneContactNumber));
  //         _sharedPreferences.setStringList(
  //             "friendsNumber", friendsNumberFromServer);
  //       }

  //       print("Number of Friend got from Server : ${friendsNumberFromServer}");
  //     } else {}
  //   } else {
  //     // In this Block we keep track of new contact number is added in the device
  //     print(
  //         "In this Block we keep track of new contact number is added in the device");
  //     List<Contact> _allContact = [];

  //     var status = await Permission.contacts.status;
  //     // check user granted permission or not ?
  //     if (status.isGranted) {
  //       //fetch contact list
  //       _allContact = await ContactsService.getContacts();

  //       List<Future<void>> future = [];
  //       for (Contact _contact in _allContact) {
  //         future.add(_processContact(_contact));
  //       }

  //       await Future.wait(future);

  //       print(
  //           "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $filteredContactNumber %%%%%%%%%%%%%%%%%%%%%%");

  //       //getting friends number from server
  //       await getFriendsNumberFromServer().then((value) {
  //         friendsNumberFromServer = value;
  //       });

  //       if (_sharedPreferences.getString("processedContact") != null &&
  //           _sharedPreferences.getStringList("friendsNumber") != null) {
  //         Map<String, dynamic> oldContact = jsonDecode(
  //             await _sharedPreferences.getString("processedContact") ?? "{}");

  //         phoneContactNumber.forEach((key, value) {
  //           if (!oldContact.containsKey(key)) {
  //             oldContact[key] = value;
  //             print(
  //                 "%%%%%%%%%%%%%%%%%%%%% Contact Update %%%%%%%%%%%%%%%%%%%%%%%");
  //           }
  //         });

  //         _sharedPreferences.setString(
  //             "processedContact", jsonEncode(oldContact));
  //       }

  //       print("Number of Friend got from Server : ${friendsNumberFromServer}");
  //     } else {}
  //   }
  // }

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

  Future<List<String>> getFriendsNumberFromServer() async {
    List<String> friendsNumber = [];
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    DateTime date = DateTime.now();
    FormatedDate = DateFormat('dd-MM-yyyy').format(date);
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateFriends";
    String getNumber_Url =
        "https://digividya.in/DigiVidyaAPI/api/updateFriends";
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

    try {
      var response = await http.post(Uri.parse(getNumber_Url), body: userData);
      if (response.statusCode == 200) {
        print("Connection");
        print("Connection established.....");
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonRespons.isNotEmpty) {
          //Cheak any number add/update in contact list if found add it in list
          for (var number = 0;
              number < jsonRespons['new_friend_list'].length;
              number++) {
            friendsNumber.add(jsonRespons['new_friend_list'][number]);
          }
        }
      } else {
        print("Connection failed ... ${response.statusCode} ");
      }
    } on HttpException catch (e) {
      print("Exception got : ${e.message.toString()}");
    }

    return friendsNumber;
  }

  // Getting User Appreciation List From Server
  void _getMyAppreciationList() async {
    // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchMyAppreciation";
    String getappreciationList_Url =
        "https://digividya.in/DigiVidyaAPI/api/fetchMyAppreciation";
    String dirPath = (await getApplicationSupportDirectory()).path;
    File JsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(JsonFile.readAsStringSync());
    String userId = jsonData['User_Id'].toString();
    List<String> AppreciatedBy = [];

    try {
      var userData = {"user_id": userId};

      var response =
          await http.post(Uri.parse(getappreciationList_Url), body: userData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        List<dynamic> myAppreciation = jsonRespons['new_friend_list'];

        //Check any one appreciate or not
        if (myAppreciation.isNotEmpty) {
          for (var number = 0; number < myAppreciation.length; number++) {
            AppreciatedBy.add(myAppreciation[number].toString());
          }
          _sharedPreferences = await SharedPreferences.getInstance();
          if (!_sharedPreferences.containsKey("UserAppreciation")) {
            _sharedPreferences.setStringList("UserAppreciation", AppreciatedBy);
          } else {
            if (_sharedPreferences
                .getStringList("UserAppreciation")!
                .isNotEmpty) {
              _sharedPreferences.setStringList(
                  "UserAppreciation", AppreciatedBy);
            } else {}
          }
        } else {
          AppreciatedBy = [];
        }
      }
    } on http.ClientException catch (e) {
      print("Exception got :${e.message.toString()}");
    }

    print("Friends Number who Appreciated You : ${AppreciatedBy}");
  }

  void prepareContact() async {
    List<Contact> _contact = await ContactsService.getContacts();
    stopwatch.start();
    print("Entering in Contact Processing Phas");
    for (var singleContact = 0;
        singleContact < _contact.length;
        singleContact++) {
      ReceivePort mainThreadReceiver = ReceivePort();
      Isolate isolate = await Isolate.spawn(filtercontact, {
        "ContactOfPerson": _contact[singleContact],
        "MainthreadPort": mainThreadReceiver.sendPort
      });
      mainThreadReceiver.listen((message) {
        phoneContactNumber[message[0].toString()] = message[1].toString();
        filteredContactNumber.add(message[1].toString());
      });

      print(
          "%%%%%%%%%%%%%%%%%%%%%%%%%% Contact Number ${singleContact + 1} is Filtered %%%%%%%%%%%%%%%%%%%%%%%%");
    }

    print(
        "Time Taken to fillter the valid MobileNumber : ${(stopwatch.elapsedMilliseconds / 1000).toString()}");

    stopwatch.stop();
  }
}

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
        print(
            "thread send this Data ${[contact.displayName!, formattedNumber]}");
        sendPort.send([contact.displayName!, formattedNumber]);
      }
    }
  }
}
