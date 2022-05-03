import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

class QRView extends StatelessWidget {
  const QRView({Key? key}) : super(key: key);
  static const routeName = '/qr/';

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode demo'),
      ),
      body: Center(child: Column(
        children: [
          const SizedBox(height: 20),
          Text("Nom Tenda", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height : 20),
          Text("Descripció de descompte", style: TextStyle(fontSize: 15)),
          const SizedBox(height : 20),
          Stack( 
        alignment: Alignment.center,
        children: [
        BarcodeWidget(
          barcode: Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high,), // Barcode type and settings
          data: 'QR data', // Content
          width: screenwidth,
        ),
      Container(
      color: Colors.white,
      width: 42,//screenwidth*0.2,
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
          const Text('123', style: TextStyle(fontSize: 20)), 
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