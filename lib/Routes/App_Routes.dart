import 'package:digividya/Ads/Banner.dart';
import 'package:digividya/screens/AssessmentPlayer.dart';
import 'package:digividya/screens/SectionPage.dart';
import 'package:digividya/screens/SubTopicPage.dart';
import 'package:digividya/screens/TopicPage.dart';
import 'package:digividya/screens/VideoPlayer.dart';
import 'package:flutter/material.dart';

// Define a class named `app_routes` to manage route generation
class app_routes {
  // Static method to generate routes based on the provided settings
  static Route<dynamic> generatorRoute(RouteSettings routeSettings) {
    // Extract arguments from the route settings
    var args = routeSettings.arguments;
    // Handle route for the root path
    if (routeSettings.name == '/') {
      // Return a custom route with specific settings for sectionPage
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => sectionPage(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle route for the '/TopicPage' path
    else if (routeSettings.name == '/TopicPage') {
      // Return a custom route with specific settings for topicPage
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => topicPage(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle route for the '/subTopicPage' path
    else if (routeSettings.name == '/subTopicPage') {
      // Return a custom route with specific settings for supTopicPage
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => supTopicPage(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle route for the '/vidoePage' path
    else if (routeSettings.name == '/vidoePage') {
      // Return a custom route with specific settings for videoPlayer
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => videoPlayer(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle route for the '/assessmentPage' path
    else if (routeSettings.name == '/assessmentPage') {
      // Return a custom route with specific settings for assessmentPlayer
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => assessmentPlayer(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle route for the '/bannerAd' path
    else if (routeSettings.name == '/bannerAd') {
      // Return a custom route with specific settings for bannerad
      return _buildRoute(
          settings: RouteSettings(arguments: args),
          pageBuilder: (context, p1, p2) => bannerad(),
          begin: Offset(4.0, 0.0),
          end: Offset.zero,
          curvedIn: Curves.easeIn,
          curvedOut: Curves.easeOut);
    } // Handle undefined routes
    else {
      // Return a default route showing an error message
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

  // Private static method to build custom routes with animation
  static PageRouteBuilder _buildRoute(
      {required var settings,
      required Widget Function(
              BuildContext context, Animation<double>, Animation<double>)
          pageBuilder,
      required Offset begin,
      required Offset end,
      required Curve curvedIn,
      required Curve curvedOut}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: pageBuilder,
      transitionDuration: Duration(seconds: 2), // Set transition duration
      reverseTransitionDuration:
          Duration(seconds: 1), // Set reverse transition duration
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define forward animation with tween and curve
        var tweenForward =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curvedIn));
        // Apply slide transition to the route
        return SlideTransition(
          position: animation.drive(
            tweenForward,
          ),
          child: child,
        );
      },
    );
  }

  // void createAppLink(String? path) async {
  //   final UserData = {"section": (1).toString(), "topic_count": (5).toString()};
  //   final uri = Uri.https("digividya.in", path ?? "", UserData);
  //   print("%%%%%%%%%%%%%%%%%%% ${uri} %%%%%%%%%%%%%%%%%%%%%");
  // }
}
