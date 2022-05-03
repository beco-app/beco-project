import 'package:beco/views/DetailView.dart';
import 'package:beco/views/QRView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beco/Stores.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:beco/Stores.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<Stores> storeList;
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
    storeList = getHomepageStores();
  }

  Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _scanBarcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(_scanBarcode);
    } on Exception catch (exception) {
      _scanBarcode = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      // SliverAppBar(floating: true, actions: <Widget>[
      //   SizedBox(height: 20), //sliver app bar doesnt work with stateful widget
      //   IconsRow(),
      // ]),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  scanBarcodeNormal(); 
                },
                child: Container ( //Button config     
                        child: Icon(
                          Icons.camera_alt,
                          size:  30,
                        ),
                      ),
                  ),
            InkWell(
                onTap: () {
                  QRView(); 
                },
                child: Container ( //Button config     
                        child: Icon(
                          Icons.qr_code,
                          size:  30,
                        ),
                      ),
                  ),
            const SizedBox(height: 20), 
            IconsRow(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<Stores>(
                future: storeList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var i = 0; i < snapshot.data!.stores.length; i++)
                          Column(
                            children: [
                              ShopButton(
                                store: snapshot.data!.stores[i],
                              ),
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
            )
          ]))
    ]);
  }
}

Map<String, IconData> myIcons = {
  "Accessible": Icons.accessible_sharp,
  "For children": Icons.child_friendly,
  "Beverages": Icons.emoji_food_beverage,
  "Restaurant": Icons.local_dining,
  "Herbalist": Icons.local_pharmacy,
  "Pharmacy": Icons.healing,
  "Bakery": Icons.bakery_dining,
  "Recycled material": Icons.recycling,
  "Green space": Icons.nature_people,
  "Plastic free": Icons.panorama_outlined,
  "Bar": Icons.local_cafe_outlined,
  "Second hand": Icons.refresh,
  "Others": Icons.question_mark,
  "Allows pets": Icons.pets_sharp,
  "Vegan food": Icons.emoji_nature,
  "Supermarket": Icons.local_grocery_store,
  "Local products": Icons.location_on,
  "Fruits and vegetables": Icons.location_on,
  "Vegetarian food": Icons.location_on,
};

class ShopButton extends StatelessWidget {
  const ShopButton({
    required this.store,
    Key? key,
  }) : super(key: key);

  final Store store;

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
                Navigator.pushNamed(
                  context,
                  DetailView.routeName,
                  arguments: store,
                );
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //             '/detail/',
                //             (route) => false,
                //           );
              },
              child: Container(
                //Button config
                //width: screenwidth * 0.95,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(// Everything inside the button
                    children: [
                  const SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.4),
                    child: Column(
                        //Text, short description and Icons
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.shopname,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 5),
                          Text(
                            store.type,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            //Icons
                            children: [
                              for (String word in store.tags)
                                Icon(
                                  myIcons[word],
                                  size: 20,
                                )
                            ],
                          ),
                        ]),
                  ),
                  const Spacer(),
                  Image.network(
                    store.photo,
                    width: screenwidth * 0.4,
                    height: screenheight * 0.15,
                    fit: BoxFit.cover,
                  )
                ]),
              ))),
    );
  }
}

class IconsRow extends StatefulWidget {
  const IconsRow({Key? key}) : super(key: key);

  @override
  State<IconsRow> createState() => _IconsRow();
}

class _IconsRow extends State<IconsRow> {
  Color? myColor = Colors.grey[350];
  @override
  Widget build(context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var word in myIcons.keys)
              Row(children: [
                const SizedBox(width: 20),
                TagsButton(word: word)
              ]),
            const SizedBox(width: 20),
          ],
        ));
  }
}

class TagsButton extends StatefulWidget {
  const TagsButton({required this.word, Key? key}) : super(key: key);
  final String word; //= "Unknown";

  @override
  State<TagsButton> createState() => _TagsButton();
}

class _TagsButton extends State<TagsButton> {
  Color? myColor = Colors.grey[350];
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () {
            setState(() {
              myColor == Colors.grey[350]
                  ? myColor = Colors.grey[500]
                  : myColor = Colors.grey[350];
            });
          },
          //isSelected ? false : true;}, //acabar
          child: Container(
              //Button config
              decoration: BoxDecoration(
                color:
                    myColor, //isSelected ? Colors.grey[350] : Colors.grey[950],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(// Everything inside the button
                    children: [
                  Icon(
                    myIcons[widget.word],
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.word,
                  ),
                ]),
              )),
        ));
  }
}
