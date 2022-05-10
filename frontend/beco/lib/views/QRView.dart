import 'package:barcode_widget/barcode_widget.dart';
import 'package:beco/tools/Discounts.dart';
import 'package:flutter/material.dart';

class QRView extends StatelessWidget {
  const QRView({Key? key}) : super(key: key);
  static const routeName = '/qr/';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Discount;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected discount'),
      ),
      body: Center(child: Column(
        children: [
          const SizedBox(height: 20),
          Text(args.shopname, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height : 20),
          Text(args.description, style: TextStyle(fontSize: 15)),
          const SizedBox(height : 20),
          Stack( 
        alignment: Alignment.center,
        children: [
        BarcodeWidget(
          barcode: Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high,), // Barcode type and settings
          data: args.id, // Content
          width: screenwidth,
        ),
      Container(
      color: Colors.white,
      width: 30,//screenwidth*0.2,
      child: Image.asset(
                          "assets/images/logo_black.png",
                          fit: BoxFit.cover,
                        ),
    ),
      ]
    ), 
    const SizedBox(height : 20),
    Row(children: [
          const Spacer(), 
          Image.asset(
            "assets/images/becoin.png",
            width: 40,
          ), 
          const SizedBox(width: 10),
          Text(args.becoins.toString(), style: TextStyle(fontSize: 20)), 
          const Icon(Icons.arrow_drop_down, color: Colors.red, size: 30),
          const Spacer()]),
      SizedBox(height: 10),
      Material(
      borderRadius: BorderRadius.circular(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: Container ( //Button config
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15,10,15,10), 
            child: Text("I'm done!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          )
        ),
      )
    ),
                  ]
      )
      ));
  }
}