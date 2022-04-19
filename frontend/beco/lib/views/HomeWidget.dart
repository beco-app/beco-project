import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RecommendedShops.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<Shops> storeList;

  @override
  void initState() {
    super.initState();
    storeList = getHomepageStores();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(floating: true, actions: <Widget>[
        SizedBox(height: 20),
        IconsRow(),
      ]),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            const SizedBox(height: 20),
            IconsRow(),
            Padding(
              padding: const EdgeInsets.all(32),
              child: FutureBuilder<Shops>(
                future: storeList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        // Text(snapshot.data!.stores[0].name.toString()),
                        for (var i = 0; i < 20; i++)
                          Column(
                            children: [
                              ShopButton(
                                  shopName: snapshot.data!.stores[i].name,
                                  imgPath: snapshot.data!.stores[i].image,
                                  shortDescr: snapshot.data!.stores[i].type,
                                  icons: snapshot.data!.stores[i].tags),
                              const SizedBox(height: 20),
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
              ),
              //       ShopButton(
              //           shopName: storeList[i],
              //           imgPath: "assets/images/logo.png",
              //           shortDescr: "Ice cream shop",
              //           icons: ['accessible_sharp', "child_friendly"]),
              //       const SizedBox(height: 20),
              //   ],
              // )
            )
          ]))
    ]);
  }
}

Map<String, IconData> myIcons = {
  "accessible": Icons.accessible_sharp,
  "or children": Icons.child_friendly,
  "beverages": Icons.local_drink,
  "restaurant": Icons.local_dining,
  "herbalist": Icons.local_pharmacy,
  "pharmacy": Icons.healing,
  "bakery": Icons.healing,
};

class ShopButton extends StatelessWidget {
  const ShopButton({
    required this.shopName,
    required this.imgPath,
    required this.shortDescr,
    required this.icons,
    Key? key,
  }) : super(key: key);

  final String shopName; //= "Unknown";
  final String imgPath; //= "assets/images/logo.png";
  final String shortDescr; //= "No description available";
  final List<dynamic> icons; //= [];

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
              onTap: () {},
              child: Container(
                //Button config
                width: screenwidth * 0.95,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(// Everything inside the button
                    children: [
                  SizedBox(width: 20),
                  Column(
                      //Text, short description and Icons
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shopName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 5),
                        Text(
                          shortDescr,
                        ),
                        SizedBox(height: 10),
                        Row(
                          //Icons
                          children: [
                            for (String word in icons)
                              Icon(
                                myIcons[word],
                                size: 30,
                              )
                          ],
                        ),
                      ]),
                  const Spacer(),
                  Image.network(
                    imgPath,
                    width: 150, //s'ha de fer fit
                    fit: BoxFit.cover,
                  )
                ]),
              ))),
    );
  }
}

class IconsRow extends StatelessWidget {
  IconsRow({
    this.isSelected = false, //acabar
    Key? key,
  }) : super(key: key);

  bool isSelected;
  @override
  Widget build(context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var word in myIcons.keys)
              Row(children: [
                const SizedBox(width: 20),
                Material(
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                        onTap: () {
                          isSelected ? false : true;
                        }, //acabar
                        child: Container(
                            //Button config
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  350], //isSelected ? Colors.grey[350] : Colors.grey[950],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(// Everything inside the button
                                  children: [
                                Icon(
                                  myIcons[word],
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  word,
                                ),
                                Text(
                                  isSelected ? "True" : "False", // acabar
                                ),
                              ]),
                            ))))
              ]),
            SizedBox(width: 20),
          ],
        ));
  }
}
