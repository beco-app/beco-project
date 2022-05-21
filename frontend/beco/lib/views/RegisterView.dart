import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:multiselect/multiselect.dart';

// Created to save the user data and send it to backend.
class User {
  late final String user_id;
  late final String email;
  late final String password;
  late final String phone;
  late final String zipcode;
  late final String gender;
  late final int birthday;
  late final List<String> preferences;

  Map<dynamic, dynamic> toJson() => {
        'user_id': user_id,
        'email': email,
        'password': password,
        'phone': phone,
        'zipcode': zipcode,
        'gender': gender,
        'birthday': birthday.toString(),
        'preferences': preferences.toString(),
      };
}

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final zipcodeList = [
    "08010",
    "08011",
    "08012",
    "08013",
    "08014",
    "08015",
    "08016",
    "08017",
    "08018",
    "08019",
    "08020",
    "08021",
    "08022",
    "08023",
    "08024",
    "08025",
    "08026",
    "08027",
    "08028",
    "08029",
    "08030",
    "08031",
    "08032",
    "08033",
    "08034",
    "08035",
    "08036",
    "08037",
    "08038",
    "08039",
    "08040",
    "08041",
    "08042"
  ];
  int emailecode = 0;
  final GlobalKey<FormFieldState> emailKey = GlobalKey();
  final GlobalKey<FormFieldState> passwordKey = GlobalKey();
  final GlobalKey<FormFieldState> phoneKey = GlobalKey();
  final GlobalKey<FormFieldState> zipcodeKey = GlobalKey();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phone;
  late final TextEditingController _zipcode;
  String gender = 'Prefer not to answer';
  DateTime date = DateTime.now();
  List<String> preferencesSelected = [];

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _phone = TextEditingController();
    _zipcode = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _zipcode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(184, 118, 185, 124),
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      ...[
                        TextFormField(
                          key: emailKey,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (emailecode == 1) {
                              emailecode = 0;
                              return "This user already exists";
                            } else if (emailecode == 2) {
                              emailecode = 0;
                              return "Invalid email";
                            }
                            return null;
                          },
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                        ),
                        TextFormField(
                          key: passwordKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (value.length < 6) {
                              return "Weak password";
                            }
                            return null;
                          },
                          controller: _password,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                        ),
                        TextFormField(
                          key: phoneKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                          controller: _phone,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            labelText: 'Phone number',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                        ),
                        TextFormField(
                          key: zipcodeKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (!zipcodeList.contains(value)) {
                              return "Zipcode must be between 08010 and 08042";
                            }
                            return null;
                          },
                          controller: _zipcode,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Zip code',
                            labelText: 'Zip code',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                          isExpanded: true,
                          value: gender,
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          items: <String>[
                            'Prefer not to answer',
                            'Male',
                            'Female',
                            'Other'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropDownMultiSelect(
                          decoration: const InputDecoration(
                            labelText: 'Preferences',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                          ),
                          onChanged: (List<String> x) {
                            setState(() {
                              preferencesSelected = x;
                            });
                          },
                          // isDense: true,
                          selectedValues: preferencesSelected,
                          whenEmpty: 'Select your preferences',
                          options: <String>[
                            'Restaurant',
                            'Bar',
                            'Supermarket',
                            'Bakery',
                            'Vegan food',
                            'Beverages',
                            'Local products',
                            'Green space',
                            'Plastic free',
                            'Herbalist',
                            'Second hand',
                            'Cosmetics',
                            'Pharmacy',
                            'Fruits & vegetables',
                            'Recycled material',
                            'Accessible',
                            'For children',
                            'Allows pets'
                          ],
                        ),
                        _FormDatePicker(
                          date: date,
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // if ((!emailKey.currentState!.validate() &&
                        //     !passwordKey.currentState!.validate() &&
                        //     !phoneKey.currentState!.validate() &&
                        //     !zipcodeKey.currentState!.validate())) {
                        var user = User();
                        user.email = _email.text;
                        user.password = _password.text;
                        user.phone = _phone.text;
                        user.zipcode = _zipcode.text;
                        user.birthday = date.millisecondsSinceEpoch ~/ 1000;
                        user.gender = gender;
                        user.preferences = preferencesSelected;
                        try {
                          emailKey.currentState!.validate();
                          passwordKey.currentState!.validate();
                          phoneKey.currentState!.validate();
                          zipcodeKey.currentState!.validate();
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: user.email,
                            password: user.password,
                          );
                          user.user_id =
                              await FirebaseAuth.instance.currentUser!.uid;
                          print("After createUser");
                          // Send user to backend
                          final r = await http.post(
                              Uri.parse('http://34.252.26.132/register_user'),
                              body: user.toJson());

                          print(r.body);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login/',
                            (route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            emailecode = 1;
                            emailKey.currentState!.validate();
                            print('Email 1');
                          } else if (e.code == 'invalid-email') {
                            emailecode = 2;
                            emailKey.currentState!.validate();
                            print('Email 2');
                          }
                          print("ERROR MESSAGE");
                          print(e);
                        }
                        print("prova");
                        //}
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(184, 118, 185, 124),
                        onSurface: Colors.grey,
                      ),
                      child: const Text('Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login/',
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                          primary: const Color.fromARGB(184, 90, 141, 94),
                          backgroundColor: Colors.grey[50],
                          onSurface: Colors.grey,
                          elevation: 0),
                      child: const Text('Have you already registerd? Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pop-up widget to select the birth date.
class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date of Birth',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMMMMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text(
            'Edit',
            style: TextStyle(
                color: const Color.fromARGB(184, 90, 141, 94),
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
