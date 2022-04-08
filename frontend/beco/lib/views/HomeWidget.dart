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
      slivers: [
        SliverAppBar(
          floating: true,
          actions: <Widget>[
            SizedBox(height: 20),
            IconsRow(),
          ]
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children:[
                SizedBox(height: 20),
                IconsRow(),
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
                SizedBox(height: 20),
                ShopButton(shopName: "Bodevici", imgPath:"assets/images/logo.png", shortDescr: "Ice cream shop", icons: ['accessible_sharp', "child_friendly"]),
              ]
            )
          )
        )
      ]
    );
  }
}

Map<String, IconData> myIcons =
    {
      "accessible_sharp": Icons.accessible_sharp, 
      "child_friendly":  Icons.child_friendly,
      "vertical_align_top_sharp": Icons.vertical_align_top_sharp,
      "vertical_align1": Icons.vertical_align_top_sharp, 
      "vertical_align2": Icons.vertical_align_top_sharp,
      "vertical_align3": Icons.vertical_align_top_sharp,
      "vertical_align4": Icons.vertical_align_top_sharp,
    };

class ShopButton extends StatelessWidget {
  const ShopButton({
    required this.shopName,
    required this.imgPath,
    required this.shortDescr,
    required this.icons,
    Key? key,
  }) : super(key: key);

  final String shopName;
  final String imgPath;
  final String shortDescr;
  final List<String> icons;

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
                Column( //Text, short description and Icons
                  children:[
                    Text(
                      shopName,
                    ),
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
  const IconsRow({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(      children: [
        for (var word in myIcons.keys) Row(
          children: [
            SizedBox(width: 20),
            Material(
              borderRadius: BorderRadius.circular(30),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {},
                child: Container ( //Button config
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: 
                  Row( // Everything inside the button
                    children: [
                      Text(
                        word,
                        ),
                      Icon(
                        myIcons[word],
                        size: 30,
                        )
                    ]
                  ),
                ) 
              )
            )
          ]
        )
      ],)
    );
  }
}




