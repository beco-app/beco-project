import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          actions: <Widget>[
            SizedBox(height: 20),
            IconsRow(),
          ]
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
              children:[
                const SizedBox(height: 20),
                IconsRow(),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['Accessible', "For children"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                      SizedBox(height: 20),
                      ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
                    ],
                  )
                )
              ]
            )
          )
      ]
    );
  }
}

Map<String, IconData> myIcons =
    {
      "Accessible": Icons.accessible_sharp, 
      "For children":  Icons.child_friendly,
      "Beverages": Icons.local_drink,
      "Restaurant": Icons.local_dining,
      "Herbalist":Icons.local_pharmacy,
      "Pharmacy": Icons.healing, 
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
  final List<String> icons; //= [];

  @override
  Widget build(context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Center(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () {},
          child: 
          Container ( //Button config
            width: screenwidth*0.95,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.black, width: 1), 
              borderRadius: BorderRadius.circular(30),
            ),
            child: 
            Row( // Everything inside the button
              children: [
                SizedBox(width: 20),
                Column( //Text, short description and Icons
                  children:[
                    Text(
                      shopName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    SizedBox(height: 5),
                    Text(
                      shortDescr,
                    ),
                    SizedBox(height: 10),
                    Row( //Icons
                      children: [
                        for (String word in icons) Icon(
                          myIcons[word],
                          size: 30,
                          )
                      ],
                    ),
                  ]
                ),
                const Spacer(),
                Image.asset(
                      imgPath,
                      width: 150, //s'ha de fer fit
                      fit: BoxFit.cover,
                )
              ]
            ),
          ) 
        )
      ),
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
      child: Row(      children: [
        for (var word in myIcons.keys) Row(
          children: [
            const SizedBox(width: 20),
            Material(
              borderRadius: BorderRadius.circular(30),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {isSelected ? false : true;}, //acabar
                child: Container ( //Button config
                  decoration: BoxDecoration(
                    color: Colors.grey[350],//isSelected ? Colors.grey[350] : Colors.grey[950],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(padding: const EdgeInsets.fromLTRB(10,5,10,5), 
                  child:
                    Row( // Everything inside the button
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
                      ]
                    ),
                  )
                ) 
              )
            )
          ]
        ),
        SizedBox(width: 20),
      ],
      )
    );
  }
}




