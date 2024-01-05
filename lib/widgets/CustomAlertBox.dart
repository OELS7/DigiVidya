import 'package:flutter/material.dart';

// ignore: must_be_immutable
class customAlertBox extends StatefulWidget {
  String alertTitle;
  final positiveFunction;
  final negativeFunction;
  String content;
  String positiveButtonTitle;
  String negativeButtonTitle;
  double height;

  customAlertBox(
      {super.key,
      required this.alertTitle,
      required this.content,
      required this.positiveFunction,
      required this.negativeFunction,
      required this.positiveButtonTitle,
      required this.negativeButtonTitle,
      required this.height});

  @override
  State<customAlertBox> createState() => _customAlertBoxState();
}

// ignore: camel_case_types
class _customAlertBoxState extends State<customAlertBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(
          child: Text(
            widget.alertTitle,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * widget.height,
          width: MediaQuery.of(context).size.width * 1,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.content,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.7,
                                  MediaQuery.of(context).size.height * 0.08)),
                          onPressed: widget.positiveFunction,
                          child: Text(widget.positiveButtonTitle),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.7,
                                  MediaQuery.of(context).size.height * 0.08)),
                          onPressed: widget.negativeFunction,
                          child: Text(widget.negativeButtonTitle))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
