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

  Map<dynamic, String> toJson() => {
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
        title: const Text('Register'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  ...[
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    TextField(
                      controller: _password,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    TextField(
                      controller: _phone,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
                        labelText: 'Phone number',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    TextField(
                      controller: _zipcode,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Zip code',
                        labelText: 'Zip code',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          var user = User();
                          user.email = _email.text;
                          user.password = _password.text;
                          user.phone = _phone.text;
                          user.zipcode = _zipcode.text;
                          user.birthday = date.millisecondsSinceEpoch;
                          user.gender = gender;
                          user.preferences = preferencesSelected;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: user.email,
                              password: user.password,
                            );
                            user.user_id =
                                await FirebaseAuth.instance.currentUser!.uid;
                            // Send user to backend
                            final r = await http.post(
                                Uri.parse('http://18.219.12.116/register_user'),
                                body: user.toJson());

                            print(r.body);

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/',
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('User not found');
                            }
                            print("ERROR MESSAGE");
                            print(e);
                          }
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login/',
                            (route) => false,
                          );
                        },
                        child: const Text('Log In',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
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
          child: const Text('Edit'),
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
