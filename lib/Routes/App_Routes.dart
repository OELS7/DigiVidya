import 'package:digividya/Ads/Banner.dart';
import 'package:digividya/screens/AssessmentPlayer.dart';
import 'package:digividya/screens/SectionPage.dart';
import 'package:digividya/screens/SubTopicPage.dart';
import 'package:digividya/screens/TopicPage.dart';
import 'package:digividya/screens/VideoPlayer.dart';
import 'package:flutter/material.dart';

class app_routes {
  static Route<dynamic> generatorRoute(RouteSettings routeSettings) {
    var args = routeSettings.arguments;
    if (routeSettings.name == '/') {
      return MaterialPageRoute(
          builder: (context) => sectionPage(),
          settings: RouteSettings(arguments: args));
    } else if (routeSettings.name == '/TopicPage') {
      return MaterialPageRoute(
          builder: (context) => topicPage(),
          settings: RouteSettings(arguments: args));
    } else if (routeSettings.name == '/subTopicPage') {
      return MaterialPageRoute(
          builder: (context) => supTopicPage(),
          settings: RouteSettings(arguments: args));
    } else if (routeSettings.name == '/vidoePage') {
      return MaterialPageRoute(
          builder: (context) => videoPlayer(),
          settings: RouteSettings(arguments: args));
    } else if (routeSettings.name == '/assessmentPage') {
      return MaterialPageRoute(
          builder: (context) => assessmentPlayer(),
          settings: RouteSettings(arguments: args));
    } else if (routeSettings.name == '/bannerAd') {
      return MaterialPageRoute(
          builder: (context) => bannerad(),
          settings: RouteSettings(arguments: args));
    } else {
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: SafeArea(
              child: Center(
            child: Text("Wrong route"),
          )),
        ),
      );
    }
  }
}
