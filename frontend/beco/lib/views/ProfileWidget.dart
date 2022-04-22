import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                // InfoContainer(attribute: 'Username', content: 'm.garcia'),
                InfoContainer(
                    attribute: 'Username', content: getUser().toString()),
                const SizedBox(height: 20),
                const InfoContainer(
                    attribute: 'Mail',
                    content: 'martag@gmail.com'), //TO DO: Check length
                const SizedBox(height: 20),
                const InfoContainer(
                    attribute: 'Phone', content: '+34 999 999 999'),
                const SizedBox(height: 20),
                const InfoContainer(attribute: 'Zipcode', content: '62954'),
                const SizedBox(height: 20),
                const InfoContainer(
                    attribute: 'Diet',
                    content: 'No preference'), //WHEN THERES TIME: Able changes
                const SizedBox(height: 20),
                const InfoContainer(attribute: 'Gender', content: 'Woman'),
                const SizedBox(height: 20),
                const InfoContainer(
                    attribute: 'Birthday', content: '31/12/1999')
              ])))
    ]);
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

Future<String> getUser() async {
  // https://stackoverflow.com/questions/65291888/flutter-web-http-error-uncaught-in-promise-error-xmlhttprequest-error/67830000#67830000
  try {
    final r = await http.get(Uri.parse('http://18.219.12.116/user_info/user1'));
    print('-----------------------------');
    print(r.body);
    print(r.statusCode);
    //r = r.toString();
    print(r);
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

// FutureBuilder<Stores>(
//                 future: storeList,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Column(
//                       children: [
//                         // Text(snapshot.data!.stores[0].name.toString()),
//                         for (var i = 0; i < 20; i++)
//                           Column(
//                             children: [
//                               ShopButton(
//                                   shopName: snapshot.data!.stores[i].shopname,
//                                   imgPath: snapshot.data!.stores[i].photo,
//                                   shortDescr: snapshot.data!.stores[i].type,
//                                   icons: snapshot.data!.stores[i].tags),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                       ],
//                     );
