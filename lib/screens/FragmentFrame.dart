import 'package:digividya/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class fragmentFrame extends StatefulWidget {
  const fragmentFrame({super.key});

  @override
  State<fragmentFrame> createState() => _fragmentFrameState();
}

class _fragmentFrameState extends State<fragmentFrame> {
  int lessionNumber = 0;
  late SharedPreferences _sectionCompleted;
  bool sectionFlag = false;
  @override
  void initState() {
    super.initState();
    initSharePreference();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: app_routes.generatorRoute,
    );
  }

  void initSharePreference() async {
    _sectionCompleted = await SharedPreferences.getInstance();
    sectionFlag = _sectionCompleted.getBool("sectionCompletedFag") ?? false;
  }
}
