import 'dart:math';
import 'package:digividya/screens/Language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController codecontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();

  var countrycode;
  String deviceId = "";

  @override
  void initState() {
    super.initState();

    deviceId = generateDevicId();
    print("The Device Id : $deviceId amd length : ${deviceId.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/app_log/DigiVidyaLogo.webp')),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Fontmain',
                          color: Colors.black,
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: namecontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Filed can not be empty";
                        } else {
                          if (RegExp(r'^[A-Za-z_. ]+$').hasMatch(value)) {
                            return null;
                          } else {
                            return "Please Enter the valid name";
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 21, 126, 212),
                          prefixIcon: Icon(
                            Icons.supervised_user_circle_sharp,
                            color: Colors.black,
                            size: 30,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 20,
                              color: Colors.black),
                          hintStyle: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 25,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: IntlPhoneField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: mobilecontroller,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            fontFamily: 'fontmain',
                            fontSize: 20,
                            color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      languageCode: "en",
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ' + country.name);
                      },
                      initialCountryCode: 'IN',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextFormField(
                      controller: citycontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your city name';
                        } else {
                          if (RegExp(r'^[A-Za-z_. ]+$').hasMatch(value)) {
                            return null;
                          } else {
                            return "Please Enter the valid city name";
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 21, 126, 212),
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.black,
                            size: 30,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'City',
                          labelStyle: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 20,
                              color: Colors.black),
                          hintStyle: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 25,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        print(namecontroller.text);
                        print(citycontroller.text);

                        setState(() {
                          print("codecontroller.text.toString()" +
                              "mobilecontroller.text.toString()");
                        });
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => languagePage(),
                                  settings: RouteSettings(arguments: {
                                    'Username': namecontroller.text,
                                    'mobileNo': mobilecontroller.text,
                                    'city': citycontroller.text,
                                    'deviceId': deviceId
                                  })));
                        }
                      },
                      child: Container(
                        height: 85,
                        width: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/submit_btn.webp'),
                                fit: BoxFit.fill)),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Fontmain',
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  //Function to generate random device ID
  String generateDevicId() {
    String stringPattern =
        "+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789!@#%^&*()";
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      50,
      (_) => stringPattern.codeUnitAt(random.nextInt(stringPattern.length)),
    ));
  }
}
