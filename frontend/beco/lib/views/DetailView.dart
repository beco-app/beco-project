import 'package:beco/Stores.dart';
import 'package:beco/tools/Discounts.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    // discountList = getStores();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store;
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
                    child: Image.asset("assets/images/media_4.png",
                        fit: BoxFit.cover)),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                            onTap: () {},
                            child: Image.network(
                              args.photo,
                              width: 150,
                              height: 150, //s'ha de fer fit
                              fit: BoxFit.cover,
                            )))),
              ])),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Text(args.shopname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: 10),
                  Text("${args.type[0].toUpperCase()}${args.type.substring(1)}",
                      style: const TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("Description",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 10),
                  Text(
                    args.description,
                  ),
                  SizedBox(height: 20),
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
                  Text("Features",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 10),
                  for (var word in args.tags)
                    Row(children: [
                      Icon(
                        myIcons[word],
                        size: 30,
                      ),
                      SizedBox(width: 20),
                      Text(word.toString())
                    ]),
                  SizedBox(height: 20),
                  Text("Where are we?",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
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
