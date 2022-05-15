import 'package:barcode_widget/barcode_widget.dart';
import 'package:beco/tools/Discounts.dart';
import 'package:flutter/material.dart';
import 'package:beco/views/DetailView.dart';
import 'package:beco/views/QRView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beco/Stores.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:beco/Stores.dart';
import 'package:filter_list/filter_list.dart';
import 'package:beco/globals.dart' as globals;
import '../Users.dart';

class QRView extends StatelessWidget {
  const QRView({Key? key}) : super(key: key);
  static const routeName = '/qr/';

  void _initUser() async {
    globals.user = await getUser();
    FlutterNativeSplash.remove();
  }

  substractBecoins(String becoins) async {
    var response = await http
        .post(Uri.parse("http://34.252.26.132/api/add_becoins"), body: {
      "user_id": await FirebaseAuth.instance.currentUser!.uid,
      "becoins": "-" + becoins
    });
    _initUser();
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Discount;
    double screenwidth = MediaQuery.of(context).size.width;
    substractBecoins(args.becoins.toString()); // <--
    return Scaffold(
        appBar: AppBar(
          title: const Text('Selected discount'),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 20),
          Text(args.shopname,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(args.description, style: TextStyle(fontSize: 15)),
          const SizedBox(height: 20),
          Stack(alignment: Alignment.center, children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(
                errorCorrectLevel: BarcodeQRCorrectionLevel.high,
              ), // Barcode type and settings
              data: args.id, // Content
              width: screenwidth,
            ),
            Container(
              color: Colors.white,
              width: 30, //screenwidth*0.2,
              child: Image.asset(
                "assets/images/logo_black.png",
                fit: BoxFit.cover,
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            const Spacer(),
            Image.asset(
              "assets/images/becoin.png",
              width: 40,
            ),
            const SizedBox(width: 10),
            Text(args.becoins.toString(), style: TextStyle(fontSize: 20)),
            const Icon(Icons.arrow_drop_down, color: Colors.red, size: 30),
            const Spacer()
          ]),
          SizedBox(height: 10),
          Material(
              borderRadius: BorderRadius.circular(30),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home/',
                    (route) => false,
                  );
                },
                child: Container(
                    //Button config
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Text("I'm done!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    )),
              )),
        ])));
  }
}
