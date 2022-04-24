import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
// import 'package:mongo_dart/mongo_dart.dart'
//    as mongo; // flutter pub add mongo_dart

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    var userinfo = getUser();

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
                // InfoContainer(
                //     attribute: 'Username', content: userinfo.value['username']),
                // InfoContainer(
                //     attribute: 'Username', content: getUser().toString()),
                infoContainerFromFuture('Username', 'username', userinfo),
                const SizedBox(height: 20),
                // FutureBuilder<String>(
                //     future: userinfo,
                //     builder: (context, snapshot) {
                //       String userinfo = snapshot.data!.toString();
                //       String mail = userinfo
                //           .substring(2, userinfo.length - 1)
                //           .split(',')[2]
                //           .split(':')[1];
                //       mail = mail.substring(2,
                //           mail.length - 1); // start from 2 as there is a space
                //       return InfoContainer(attribute: 'Mail', content: mail);
                //     }),
                // const InfoContainer(
                //     attribute: 'Mail',
                //     content: 'martag@gmail.com'), //TO DO: Check length
                infoContainerFromFuture('Mail', 'email', userinfo),
                const SizedBox(height: 20),
                // FutureBuilder<String>(
                //     future: userinfo,
                //     builder: (context, snapshot) {
                //       String userinfo = snapshot.data!.toString();
                //       String username = userinfo
                //           .substring(2, userinfo.length - 1)
                //           .split(',')[4]
                //           .split(':')[1];
                //       username = '+34 ' +
                //           username.substring(
                //               2,
                //               username.length -
                //                   1); // start from 2 as there is a space
                //       return InfoContainer(
                //           attribute: 'Phone', content: username);
                //     }),
                // const InfoContainer(
                //     attribute: 'Phone', content: '+34 999 999 999'),
                infoContainerFromFuture('Phone', 'phone', userinfo),
                const SizedBox(height: 20),
                // FutureBuilder<String>(
                //     future: userinfo,
                //     builder: (context, snapshot) {
                //       String userinfo = snapshot.data!.toString();
                //       String zipcode = userinfo
                //           .substring(2, userinfo.length - 1)
                //           .split(',')[7]
                //           .split(':')[1];
                //       zipcode = zipcode.substring(
                //           2,
                //           zipcode.length -
                //               1); // start from 2 as there is a space
                //       return InfoContainer(
                //           attribute: 'Zip Code', content: zipcode);
                //     }),
                // const InfoContainer(attribute: 'Zipcode', content: '62954'),
                infoContainerFromFuture('Zipcode', 'zip_code', userinfo),
                const SizedBox(height: 20),
                // FutureBuilder<String>(
                //     future: userinfo,
                //     builder: (context, snapshot) {
                //       String userinfo = snapshot.data!.toString();
                //       String diet = userinfo
                //           .substring(2, userinfo.length - 1)
                //           .split(',')[8]
                //           .split(':')[1];
                //       diet = diet.substring(3,
                //           diet.length - 1); // start from 2 as there is a space
                //       return InfoContainer(attribute: 'Diet', content: diet);
                //     }),
                const InfoContainer(
                    attribute: 'Diet',
                    content: 'No preference'), //WHEN THERES TIME: Able changes
                //infoContainerFromFuture('Diet', 'preferences', userinfo),
                const SizedBox(height: 20),
                // FutureBuilder<String>(future: userinfo, builder:(context, snapshot){
                //   String userinfo = snapshot.data!.toString();
                //   String username = userinfo.substring(2,userinfo.length-1).split(',')[1].split(':')[1];
                //   username = username.substring(2,username.length-1);  // start from 2 as there is a space
                //   return InfoContainer(attribute: 'Username', content: username);
                // }),
                // const InfoContainer(attribute: 'Gender', content: 'Woman'),
                infoContainerFromFuture('Gender', 'gender', userinfo),
                const SizedBox(height: 20),
                infoContainerFromFuture('Birthday', 'birthday', userinfo),
                // const InfoContainer(
                //     attribute: 'Birthday', content: '31/12/1999')
              ])))
    ]);
  }
}

Widget infoContainerFromFuture(
    String attribute, String key, Future<String> userinfo) {
  return FutureBuilder<String>(
      future: userinfo,
      builder: (context, snapshot) {
        User userinfo = User(snapshot.data!.toString());
        return InfoContainer(
            attribute: attribute, content: userinfo[key].toString());
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
    return Container(
        padding: const EdgeInsets.only(left: 30.0),
        height: 55,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 195, 220, 0.584),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          Container(
              width: 105,
              child: Text(attribute, style: const TextStyle(fontSize: 17))),
          Container(
            width: 300,
            height: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                maxLines: 3,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]));
  }
}

class User {
  String username;
  late Map _user;

  User(
    this.username,
  ) {
    // with help of https://regex101.com/:
    String s = username.substring(1, username.length - 1);

    // Remove some information
    final RegExp toRemove = RegExp("('password'.*?\", )" // password
        "|"
        "('_id'.*?, )"); // _id
    s = s.replaceAll(toRemove, '');

    // treat ObjectIds (change from ObjectId('123') to 'ObjectId(123)')
    s = s.replaceAllMapped(RegExp(r"(ObjectId\()(\')(.*?)(\')(\))"),
        (Match m) => "'${m[1]}${m[3]}${m[5]}'");

    // change all ' to " for json.convert
    s = s.replaceAll(RegExp("'"), '"');
    _user = json.decode(s);
  }

  String operator [](String key) {
    return _user[key].toString();
  }
}

Future<String> getUser() async {
  // https://stackoverflow.com/questions/65291888/flutter-web-http-error-uncaught-in-promise-error-xmlhttprequest-error/67830000#67830000
  try {
    var r = await http.get(Uri.parse('http://18.219.12.116/user_info/user1'));
    print(r.body);
    return r.body;
  } catch (e) {
    print('--------------------------------Errrrrrrrrrror:');
    print(e);
    return '';
  }
}

// dynamic getUser1() async {
//   // https://360techexplorer.com/connect-flutter-to-mongodb/
//   try {
//     var db = await mongo.Db.create('mongodb://127.0.0.1:27017/beco_db');
//     await db.open();
//     print('--------------------------------');
//     print(db.runtimeType);
//     var collection = db.collection('users');
//     // Standard way
//     var response = await collection
//         .findOne(mongo.where.eq("username", 'user1').fields(['username']));

//     return response;
//   } catch (e) {
//     print('--------------------------------Errrrrrrrrrror:');
//     print(e);
//     return '';
//   }
// }

// String s = FutureBuilder<String>(future: storeList, builder: (context, snapshot) {
//   if (snapshot.hasData) {
//     return Column(
//       children: [
//         // Text(snapshot.data!.stores[0].name.toString()),
//         for (var i = 0; i < 20; i++)
//           Column(
//             children: [
//               ShopButton(
//                 shopName: snapshot.data!.stores[i].shopname,
//                 imgPath: snapshot.data!.stores[i].photo,
//                 shortDescr: snapshot.data!.stores[i].type,
//                 icons: snapshot.data!.stores[i].tags
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ],
//       );
//   }
//    else if (snapshot.hasError) {
//                     return Text('${snapshot.error}');
//                   }

//                   // By default, show a loading spinner.
//                   return const CircularProgressIndicator();
//                 },
// }
