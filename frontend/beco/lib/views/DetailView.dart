import 'package:beco/Stores.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailView extends StatelessWidget {
  const DetailView({ Key? key,}) : super(key: key);
  static const routeName = '/detail/';

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
                        )
                      )
                    )
                  ),
          ])),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Text(
                  args.shopname,
                  style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)
                ),
                SizedBox(height: 10),
                Text(
                  args.type,
                  style: const TextStyle(
                    fontSize: 18)
                ),
                SizedBox(height: 20),
                Text("Description",
                    style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                Text(
                  args.description,
                ),
                SizedBox(height: 20),
                Text("Features", style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                for (var word in args.tags) Row(
                  children: [
                    Icon(
                      myIcons[word],
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Text(word.toString())
                  ]
          ),
                SizedBox(height: 20),
                Text("Where are we?", style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                Text(args.address),
                const SizedBox(height: 2000)
              ])))
    ]));
  }
  }

Map<String, IconData> myIcons = {
  "accessible": Icons.accessible_sharp,
  "for children": Icons.child_friendly,
  "beverages": Icons.emoji_food_beverage,
  "restaurant": Icons.local_dining,
  "herbalist": Icons.local_pharmacy,
  "pharmacy": Icons.healing,
  "bakery": Icons.bakery_dining,
  "recycled material": Icons.recycling,
  "green space": Icons.nature_people,
  "plastic free": Icons.panorama_outlined ,
  "bar": Icons.local_cafe_outlined,
  "second hand":Icons.refresh,
  "others": Icons.question_mark,
  "allows pets": Icons.pets_sharp,
  "vegan food": Icons.emoji_nature,
  "supermarket": Icons.local_grocery_store,
  "local products": Icons.location_on,
  "fruits and vegetables": Icons.location_on,
  "vegetarian food": Icons.location_on,
};