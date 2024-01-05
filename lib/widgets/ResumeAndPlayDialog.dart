import 'package:flutter/material.dart';

// ignore: must_be_immutable
class resumeAndPlayDialog extends StatefulWidget {
  final resume;
  final startOver;
  resumeAndPlayDialog(
      {super.key, required this.resume, required this.startOver});

  @override
  State<resumeAndPlayDialog> createState() =>
      _resumeAndPlayDialogState(resume: resume, startOver: startOver);
}

class _resumeAndPlayDialogState extends State<resumeAndPlayDialog> {
  final resume;
  final startOver;
  _resumeAndPlayDialogState({this.resume, this.startOver});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/App popups/Pop_up ICONS/downloadPopUp.webp"))),
    );
  }
}
