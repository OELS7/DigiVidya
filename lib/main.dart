import 'package:digividya/screens/Splash.dart';
import 'package:flutter/material.dart';
import 'package:digividya/Services/NotificationServices.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  _deviceOrientation();
  tz.initializeTimeZones();

  checkPermission();

  runApp(const MyApp());
}

void _deviceOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

void checkPermission() async {
  final AndroidDeviceInfo androidDeviceInfo =
      await DeviceInfoPlugin().androidInfo;
  if (androidDeviceInfo.version.sdkInt < 33) {
    Permission.contacts.request().then((_) {
      print("contact permission given");
      Permission.videos.request().then((_) {
        print("Video Permission");
        Permission.audio.request().then((_) {
          print("audio Permission given");
          Permission.scheduleExactAlarm.request().then((_) async {
            print("schedule Aleram permission given");
            await notificationService.initializedNotification();
          });
        });
      });
    });
  } else {
    Map<Permission, PermissionStatus> status = await [
      Permission.contacts,
      Permission.videos,
      Permission.audio,
      Permission.scheduleExactAlarm,
      // Permission.manageExternalStorage,
    ].request();

    // if(status[Permission.contacts.status] != null){}
    if (await Permission.contacts.isGranted &&
        // await Permission.manageExternalStorage.isGranted &&
        await Permission.videos.isGranted &&
        await Permission.audio.isGranted &&
        await Permission.scheduleExactAlarm.isGranted) {
      await notificationService.initializedNotification();
    } else {}
  }
  return;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    disableCapture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2A61C0),
            onTertiaryContainer: Color.fromARGB(255, 42, 97, 192),
            onTertiary: Color.fromARGB(255, 42, 97, 192),
            // onBackground: Color.fromARGB(255, 42, 97, 192),
            onPrimaryContainer: Color.fromARGB(255, 42, 97, 192)),
        primarySwatch: Colors.blue,
        fontFamily: 'Fontmain',
        useMaterial3: true,
      ),
      home: Splash(),
      // home: Splash(
      //   App_Name: "DigiVidya",
      // ),
    );
  }
}

Future<void> disableCapture() async {
  //disable screenshots and record screen in current screen
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
