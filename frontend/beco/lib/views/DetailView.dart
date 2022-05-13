import 'package:beco/Stores.dart';
import 'package:beco/tools/Discounts.dart';
import 'package:beco/tools/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'DiscountWidget.dart';

class DetailView extends StatefulWidget {
  const DetailView({
    Key? key,
  }) : super(key: key);
  static const routeName = '/detail/';

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late Future<Discounts> discountList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store;
    discountList = getShopDiscounts(args.id);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(slivers: [
          SliverAppBar(
              //maybe sliverpersistentheader is better
              floating: false,
              expandedHeight: 150,
              flexibleSpace:
                  //child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  Stack(children: [
                Positioned.fill(
                  child: Image.network(
                    args.photo,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      // child: InkWell(
                      //     onTap: () {},
                      //     child: Image.network(
                      //       args.photo,
                      //       width: 150,
                      //       height: 150, //s'ha de fer fit
                      //       fit: BoxFit.cover,
                      //     )
                      // )
                    )),
              ])),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Text(args.shopname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 10),
                  Text("${args.type[0].toUpperCase()}${args.type.substring(1)}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 10),
                  Text(
                    args.description.replaceAll("<br />", ""),
                  ),
                  const SizedBox(height: 20),
                  // Text("Features",
                  //     style: const TextStyle(
                  //         fontWeight: FontWeight.bold, fontSize: 12)),
                  // SizedBox(height: 10),
                  // for (var word in args.tags)
                  //   Row(children: [
                  //     Icon(
                  //       myIcons[word],
                  //       size: 30,
                  //     ),
                  //     SizedBox(height: 20),
                  const Text("Features",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 10),
                  for (var word in args.tags)
                    Row(children: [
                      Icon(
                        myIcons[word],
                        size: 30,
                      ),
                      SizedBox(width: 20),
                      Text(word.toString())
                    ]),
                  const SizedBox(height: 20),
                  const Text("Where are we?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 10),
                  Text(args.address),
                  SizedBox(height: 20),
                  Text("Pollution level",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text("Air Quality Index: "),
                      Text(double.parse((args.aqi).toStringAsFixed(2))
                          .toString()),
                      SizedBox(width: 10),
                      Container(
                          height: 30,
                          width: 30,
                          color: color_from_aqi(args.aqi)),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Discounts",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25)),
                  FutureBuilder<Discounts>(
                    future: discountList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (var i = 0;
                                i < snapshot.data!.discounts.length;
                                i++)
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  DiscountButtonDetail(
                                    shopName:
                                        snapshot.data!.discounts[i].shopname,
                                    description:
                                        snapshot.data!.discounts[i].description,
                                    becoins:
                                        snapshot.data!.discounts[i].becoins,
                                    discount: snapshot.data!.discounts[i],
                                  ),
                                ],
                              ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  )
                ]),
              ))
        ]));
  }
}

Color color_from_aqi(aqi) {
  if (aqi < 50)
    return Colors.green;
  else if ((50 <= aqi) & (aqi < 100))
    return Colors.yellow;
  else if ((100 <= aqi) & (aqi < 150))
    return Colors.orange;
  else if ((150 <= aqi) & (aqi < 200))
    return Colors.red;
  else if ((200 <= aqi) & (aqi < 300))
    return Colors.purple;
  else if (aqi >= 300) return Colors.red[900]!;

  return Colors.black;
}

Map<String, IconData> myIcons = {
  "Accessible": Icons.accessible_sharp,
  "Allows pets": Icons.pets_sharp,
  "Bakery": Icons.bakery_dining,
  "Bar": Icons.local_cafe_outlined,
  "Beverages": Icons.emoji_food_beverage,
  "Cosmetics": Icons.face_retouching_natural,
  "For children": Icons.child_friendly,
  "Fruits & vegetables": Icons.location_on,
  "Green space": Icons.nature_people,
  "Herbalist": Icons.local_pharmacy,
  "Local products": Icons.location_on,
  "Pharmacy": Icons.healing,
  "Plastic free": Icons.panorama_outlined,
  "Recycled material": Icons.recycling,
  "Restaurant": Icons.local_dining,
  "Second hand": Icons.refresh,
  "Supermarket": Icons.local_grocery_store,
  "Vegan food": Icons.emoji_nature,
  "Others": Icons.question_mark,
  "Vegetarian food": Icons.location_on,
};

class DiscountButtonDetail extends StatelessWidget {
  const DiscountButtonDetail({
    required this.shopName,
    required this.description,
    required this.becoins,
    required this.discount,
    Key? key,
  }) : super(key: key);

  final String shopName; //= "Unknown";
  final String description; //= "assets/images/logo.png";
  final int becoins;
  final Discount discount; //= "No description available";

  @override
  Widget build(context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Center(
      child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
              onTap: () {
                showAlertDialog(context, discount);
                // Navigator.pushNamed(
                //   context,
                //   QRView.routeName,
                //   arguments: discount,
                //   );
              },
              child: Container(
                //Button config
                width: screenwidth * 0.95,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(// Everything inside the button
                    children: [
                  SizedBox(width: 20),
                  Column(
                      //Text, short description and Icons
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: screenwidth * 0.4,
                                  minWidth: screenwidth * 0.4),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // Name and description
                                  children: [
                                    Text(shopName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    SizedBox(height: 5),
                                    Text(
                                      description,
                                    ),
                                  ])),
                          SizedBox(width: screenwidth * 0.1),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: screenwidth * 0.3),
                              child: Row(children: [
                                Text("$becoins becoins"),
                                SizedBox(width: 5),
                                Image.asset(
                                  'assets/images/becoin.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ])),
                        ]),
                        SizedBox(height: 10),
                        // Buttons
                        ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: screenwidth * 0.8),
                            child: Row(children: [
                              Spacer(),
                              SaveButton(
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                discountId: discount.id,
                              ),
                              Spacer(),
                              GoToShopButton(
                                  option: "Go to shop", discount: discount),
                              Spacer(),
                            ])),
                        SizedBox(height: 15),
                      ]),
                  const Spacer(),
                ]),
              ))),
    );
  }
}
