import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//    as mongo; // flutter pub add mongo_dart

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final TextEditingController _zipcontroller = TextEditingController();
  @override
  void dispose() {
    _zipcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String username = 'user1';

    double screenwidth = MediaQuery.of(context).size.width;
    var userinfo = getUser(username);
    if (userinfo == null) {
      print('You have enterd!!!!!!!!!!!!!!!');
    }
    return CustomScrollView(slivers: [
      SliverAppBar(
          //maybe sliverpersistentheader is better
          floating: false,
          expandedHeight: 150,
          flexibleSpace:
              //child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              Stack(children: [
            Positioned.fill(
                child: Image.asset("assets/images/media_4.png",
                    fit: BoxFit.cover)),
            Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 150, //s'ha de fer fit
                          //fit: BoxFit.cover,
                        )))),
          ])),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(children: [
                infoContainerFromFuture('User', 'username', userinfo),
                const SizedBox(height: 20),
                infoContainerFromFuture('Mail', 'email', userinfo),
                const SizedBox(height: 20),
                infoContainerFromFuture('Phone', 'phone', userinfo),
                const SizedBox(height: 20),
                Container(
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
                                  fontSize: 17,
                                  color: Color.fromARGB(146, 67, 67, 67)))),
                      Flexible(
                          child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FutureBuilder<String>(
                              future: userinfo,
                              builder: (context, snapshot) {
                                String content = '';
                                if (snapshot.hasData) {
                                  User userinfo =
                                      User(snapshot.data.toString());
                                  content = userinfo['zip_code'].toString();
                                } else {
                                  content = 'Loading...';
                                }
                                return TextField(
                                  controller: _zipcontroller,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: content,
                                    hintStyle: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0)),

                                    //labelText: 'Zip code',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    // border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                );
                              }),
                        ),
                      )),
                    ])),
                const SizedBox(height: 20),
                infoContainerFromFuture('Pref.', 'preferences', userinfo),
                const SizedBox(height: 20),
                infoContainerFromFuture('Gender', 'gender', userinfo),
                const SizedBox(height: 20),
                infoContainerFromFuture('Birthday', 'birthday', userinfo),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    child: const Text("Log out",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 64, 64, 64))),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 213, 213, 213),
                        padding: const EdgeInsets.all(8.0)))
              ])))
    ]);
  }
}

Widget infoContainerFromFuture(
    String attribute, String key, Future<String> userinfo) {
  return FutureBuilder<String>(
      future: userinfo,
      builder: (context, snapshot) {
        String content = '';
        if (snapshot.hasData) {
          User userinfo = User(snapshot.data.toString());
          content = userinfo[key].toString();
        } else {
          content = 'Loading...';
        }
        return InfoContainer(attribute: attribute, content: content);
      });
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
    if (attribute == 'Zipcode') {}
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
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
    onPressed: () {
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

class User {
  // Build a User class that contains the userinfo in string (returned by getUser)
  // and prepared the string to be a Map<String, String>;
  String userinfo;
  late Map _user;

  User(this.userinfo) {
    // with help of https://regex101.com/:
    String s = userinfo.substring(1, userinfo.length - 1);

    // Remove some information
    final RegExp toRemove = RegExp(r"('password'.*?, )" // password
        "|"
        "('_id'.*?, )"); // _id
    s = s.replaceAll(toRemove, '');

    // treat ObjectIds (change from ObjectId('123') to 'ObjectId(123)')
    s = s.replaceAllMapped(RegExp(r"(ObjectId\()(\')(.*?)(\')(\))"),
        (Match m) => "'${m[1]}${m[3]}${m[5]}'");

    // change all ' to " for json.convert
    s = s.replaceAll(RegExp("'"), '"');
    _user = json.decode(s);
    //print(_user);
  }

  String operator [](String key) {
    if (_user[key] == null) {
      print('You have enterd!!!!!!!!!!!!!!!');
      return '';
    }
    switch (key) {
      case 'preferences':
        switch (_user[key].length) {
          case 0:
            return 'No preferences';
          default:
            String preferences = _user[key].toString();
            return preferences.substring(1, preferences.length - 1);
        }
      case 'phone':
        //print(_user[key]);
        return '+34 ' + _user[key].toString();
      case 'gender':
        switch (_user[key]) {
          case 'M':
            return 'Male';
          case 'F':
            return 'Female';
          default:
            return _user[key];
        }
      case 'birthday':
        return DateTime.fromMillisecondsSinceEpoch(_user[key].toInt() * 1000)
            .toString()
            .substring(0, 10);
      default:
        return _user[key].toString();
    }
  }
}

Future<String> getUser(String username) async {
  // https://stackoverflow.com/questions/65291888/flutter-web-http-error-uncaught-in-promise-error-xmlhttprequest-error/67830000#67830000
  try {
    var r =
        await http.get(Uri.parse('http://34.252.26.132/user_info/' + username));
    print("<\n" + r.body + "\n>");
    if (r.body == '{"message":"User not found"}\n') {
      // this error message should not be treated in such a special way...
      throw Exception('User does not exist');
    }
    return r.body;
  } catch (e) {
    print('--------------------------------Errrrrrrrrrror:');
    print(e);
    return '';
  }
}
