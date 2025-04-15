
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
// Define a global key for the form
final _formKey = GlobalKey<FormState>();

// Initialize text editing controllers for various input fields
TextEditingController namecontroller = TextEditingController();
TextEditingController mobilecontroller = TextEditingController();
TextEditingController codecontroller = TextEditingController();
TextEditingController citycontroller = TextEditingController();

// Declare variables for country code and device ID
var countrycode;
String deviceId = "";

@override
void initState() {
  super.initState(); 
}

// Override the build method to create the widget tree
@override
Widget build(BuildContext context) {
      // Retrieve the arguments passed to the route and cast them to a Map
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, String>{}) as Map;
        deviceId = arguments["DeviceId"].toString().isEmpty ? "" :arguments["DeviceId"].toString();
         print("The Device Id : $deviceId amd length : ${deviceId.length}");
  return Scaffold(
    // Scaffold widget to provide a framework for implementing the Material Design layout structure
    body: Container(
      // Container widget to contain and align multiple widgets
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // SingleChildScrollView widget to make the content scrollable
      child: SingleChildScrollView(
        child: Form(
          // Form widget to manage the form state and form fields
          key: _formKey, // Assigning the global key to the form
          child: Column(
            // Column widget to arrange children vertically
            children: [
              Container(
                // Container to display the app logo
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/app_log/DigiVidyaLogo.webp'),
                  ),
                ),
              ),
              Container(
                // Container to display the registration text
                alignment: Alignment.center,
                child: const Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Fontmain',
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                // Container for the name input field
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  // TextFormField widget for text input
                  controller: namecontroller, // Assigning the text editing controller
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
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Fontmain',
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // Container for the phone number input field
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
                      color: Colors.black,
                    ),
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
                // Container for the city input field
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
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Fontmain',
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // Container for the submit button
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => languagePage(),
                          settings: RouteSettings(arguments: {
                            'Username': namecontroller.text,
                            'mobileNo': mobilecontroller.text,
                            'city': citycontroller.text,
                            'DeviceId': deviceId
                          }),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 85,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/submit_btn.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
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
          ),
        ),
      ),
    ),
  );
}

}
