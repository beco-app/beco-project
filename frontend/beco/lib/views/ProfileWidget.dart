import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './multiselectdropdownwidget.dart';
import '../Users.dart';
import 'package:intl/intl.dart' as intl;

//    as mongo; // flutter pub add mongo_dart

class GlobalProfileWidget extends StatefulWidget {
  const GlobalProfileWidget({Key? key}) : super(key: key);

  @override
  State<GlobalProfileWidget> createState() => _GlobalProfileWidgetState();
}

class _GlobalProfileWidgetState extends State<GlobalProfileWidget> {
  late Future<ProfileUser> futureUser;

  @override
  void initState() {
    super.initState();
    print("holaglobal");
    futureUser = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileUser>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!);
          return ProfileWidget(profileUser: snapshot.data!);
        }
        return Container(
            child: Center(child: const CircularProgressIndicator()));
      },
    );
  }
}

class ProfileWidget extends StatefulWidget {
  ProfileUser profileUser;
  ProfileWidget({Key? key, required this.profileUser}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final TextEditingController zipcode_controller =
      TextEditingController(text: widget.profileUser.zipcode);

  @override
  void initState() {
    super.initState();
    print("holis");
  }

  @override
  Widget build(BuildContext context) {
    // String username = 'user1';

    double screenwidth = MediaQuery.of(context).size.width;
    // if (userinfo == null) {
    //   print('You have enterd!!!!!!!!!!!!!!!');
    // }
    bool zip_code_editable = false;
    return CustomScrollView(slivers: [
      // SliverAppBar(
      //     //maybe sliverpersistentheader is better
      //     floating: false,
      //     expandedHeight: 150,
      //     flexibleSpace:
      //         //child: Column(
      //         //mainAxisAlignment: MainAxisAlignment.end,
      //         Stack(children: [
      //       Positioned.fill(
      //           child: Image.asset("assets/images/media_4.png",
      //               fit: BoxFit.cover)),
      //       Align(
      //           alignment: Alignment.bottomCenter,
      //           child: Material(
      //               shape: const CircleBorder(),
      //               clipBehavior: Clip.antiAliasWithSaveLayer,
      //               child: InkWell(
      //                   onTap: () {},
      //                   child: Image.asset(
      //                     "assets/images/logo.png",
      //                     width: 150, //s'ha de fer fit
      //                     //fit: BoxFit.cover,
      //                   )))),
      //     ])),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(children: [
                InfoContainer(
                    attribute: "Email", content: widget.profileUser.email),
                const SizedBox(height: 20),
                InfoContainer(
                    attribute: "Phone", content: widget.profileUser.phone),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55,
                    width: screenwidth * 0.9,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 228, 233),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(children: [
                      Container(
                          width: 70,
                          child: const Text('Gender',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(146, 67, 67, 67)))),
                      Flexible(
                          child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Gender',

                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              //border: OutlineInputBorder(),
                              //contentPadding: EdgeInsets.symmetric(

                              //    vertical: 5, horizontal: 10),
                            ),
                            isExpanded: true,
                            value: widget.profileUser.gender,
                            onChanged: (String? newValue) {
                              setState(() {
                                widget.profileUser.gender = newValue!;
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
                        ),
                      )),
                    ])),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55,
                    width: screenwidth * 0.9,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 228, 233),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(children: [
                      Container(
                          width: 70,
                          child: const Text('Pref.',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(146, 67, 67, 67)))),
                      Flexible(
                          child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DropDownMultiSelect(
                            decoration: const InputDecoration.collapsed(
                              hintText: '',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,

                              // border: OutlineInputBorder(),
                              // contentPadding: EdgeInsets.symmetric(
                              //     vertical: 5, horizontal: 10),
                            ),
                            onChanged: (List<String> x) {
                              setState(() {
                                widget.profileUser.preferences = x;
                              });
                            },
                            // isDense: true,
                            //selectedValues: preferencesSelected,
                            selectedValues: widget.profileUser.preferences,
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
                        ),
                      )),
                    ])),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 9),
                    height: 55,
                    width: screenwidth * 0.9,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 228, 233),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(children: [
                      Container(
                          width: 70,
                          child: const Text('Zipcode',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(146, 67, 67, 67)))),
                      Flexible(
                          child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            style: TextStyle(fontSize: 17),
                            controller: zipcode_controller,
                            enableSuggestions: false,
                            autocorrect: false,
                            enabled: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.edit),
                                border: InputBorder.none,
                                hintText: "",
                                hintStyle: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                //labelText: 'Zip code',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always
                                // border: const OutlineInputBorder(),
                                //contentPadding: const EdgeInsets.symmetric(
                                //    vertical: 5, horizontal: 10),
                                ),
                          ),
                        ),
                      )),
                      // Spacer(),
                      // TextButton(
                      //   child: Text(
                      //     'Edit',
                      //     style:
                      //         TextStyle(color: Theme.of(context).primaryColor),
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       zip_code_editable = true;
                      //     });
                      //   },
                      // )
                    ])),
                const SizedBox(height: 20),
                _FormDatePicker(
                  date: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.profileUser.birthday) * 1000),
                  onChanged: (value) {
                    setState(() {
                      widget.profileUser.birthday =
                          (value.millisecondsSinceEpoch ~/ 1000).toString();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          //   var user = ProfileUser();
                          //   user.email = _email.text;
                          //   user.password = _password.text;
                          //   user.phone = _phone.text;

                          widget.profileUser.zipcode = zipcode_controller.text;
                          showSaveAlertDialog(context, widget.profileUser);
                        },
                        child: const Text("Save",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 64, 64, 64))),
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 224, 224, 224),
                            padding: const EdgeInsets.all(8.0),
                            elevation: 2.0)),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        child: const Text("Log out",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 64, 64, 64))),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 224, 224, 224),
                            padding: const EdgeInsets.all(8.0),
                            elevation: 2.0)),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
              ])))
    ]);
  }
}

class TextContainer extends StatefulWidget {
  const TextContainer({
    required this.attribute,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String attribute;
  final String content;

  @override
  State<TextContainer> createState() => _TextContainer();
}

class _TextContainer extends State<TextContainer> {
  late final TextEditingController controller =
      TextEditingController(text: widget.content);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.only(left: 20.0),
        height: 55,
        width: screenwidth * 0.9,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 195, 220, 0.584),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          Container(
              width: 70,
              child: const Text('Zipcode',
                  style: TextStyle(
                      fontSize: 17, color: Color.fromARGB(146, 67, 67, 67)))),
          Flexible(
              child: Container(
            width: double.infinity,
            height: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // hintText: content,
                  hintStyle: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),

                  //labelText: 'Zip code',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  // border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
              ),
            ),
          )),
        ]));
    const SizedBox(height: 20);
  }
}

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
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      height: 55,
      width: screenwidth * 0.9,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 235, 228, 233),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Birthday',
            style:
                TextStyle(fontSize: 17, color: Color.fromARGB(146, 67, 67, 67)),
          ),
          const SizedBox(width: 10),
          Text(
            intl.DateFormat.yMMMMd().format(widget.date),
            style: TextStyle(fontSize: 17),
          ),
          Spacer(),
          TextButton(
            child: Icon(Icons.calendar_today,
                color: Color.fromARGB(146, 67, 67, 67)),
            // Text(
            //   'Edit',
            //   style: TextStyle(color: Theme.of(context).primaryColor),
            // ),
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
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    required this.attribute,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String attribute;
  final String content;

  @override
  Widget build(context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.only(left: 20.0),
        height: 55,
        width: screenwidth * 0.9,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 228, 233),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(children: [
          Container(
              width: 70,
              child: Text(attribute,
                  style: const TextStyle(
                      fontSize: 17, color: Color.fromARGB(146, 67, 67, 67)))),
          Flexible(
              child: Container(
            width: double.infinity,
            height: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.normal),
              ),
            ),
          )),
        ]));
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () async {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login/',
        (route) => false,
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Warning"),
    content: const Text("Are you sure?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSaveAlertDialog(BuildContext context, var profileUser) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Save"),
    onPressed: () async {
      //   user.birthday = date.millisecondsSinceEpoch;
      //   user.gender = profileUser.gender;
      //   user.preferences = preferencesSelected;
      try {
        // user.user_id =
        //     await FirebaseAuth.instance.currentUser!.uid;
        // Send user to backend
        final r = await http.post(Uri.parse('http://34.252.26.132/user_update'),
            body: profileUser.toJson());
        print(profileUser.toJson());

        print(r.body);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('User not found');
        }
        print("ERROR MESSAGE");
        print(e);
      }

      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Save"),
    content: const Text("Are you sure to edit your information?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
