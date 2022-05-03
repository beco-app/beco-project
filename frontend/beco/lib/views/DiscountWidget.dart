import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:beco/Stores.dart';
import 'package:beco/tools/Discounts.dart';

class DiscountWidget extends StatefulWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  State<DiscountWidget> createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  late Future<Discounts> discountList;

  @override
  void initState() {
    super.initState();
    discountList = getDiscounts();
    print(discountList);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            const SizedBox(height: 20),
            IconsRow(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<Discounts>(
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
                              DiscountButton(
                                shopName: snapshot.data!.discounts[i].shopname,
                                description:
                                    snapshot.data!.discounts[i].description,
                                becoins: snapshot.data!.discounts[i].becoins,
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

class DiscountButton extends StatelessWidget {
  const DiscountButton({
    required this.shopName,
    required this.description,
    required this.becoins,
    Key? key,
  }) : super(key: key);

  final String shopName; //= "Unknown";
  final String description; //= "assets/images/logo.png";
  final int becoins; //= "No description available";

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
                        SizedBox(height: 10),
                        Row(children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                              ]),
                          SizedBox(width: 70),
                          Row(children: [
                            Text("$becoins becoins"),
                            SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Hands Coin.png',
                              height: 20,
                              width: 20,
                            ),
                          ]),
                        ]),
                        SizedBox(height: 10),
                        // Buttons
                        Row(children: [
                          SizedBox(width: 30),
                          Button(option: "Redeem"),
                          SizedBox(width: 15),
                          Button(option: "Unsave"),
                          SizedBox(width: 15),
                          Button(option: "Go to shop"),
                        ]),
                        SizedBox(height: 5),
                      ]),
                  const Spacer(),
                ]),
              ))),
    );
  }
}

List<String> options = ['Active', 'Saved', 'Recommended'];

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
            for (var word in options)
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
          // onTap: () {
          //   setState(() {
          //     myColor == Colors.grey[350]
          //         ? myColor = Colors.grey[500]
          //         : myColor = Colors.grey[350];
          //   });
          // },
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
                  Text(
                    widget.word,
                  ),
                ]),
              )),
        ));
  }
}

// Button
class Button extends StatefulWidget {
  const Button({required this.option, Key? key}) : super(key: key);
  final String option;

  @override
  State<Button> createState() => _Button();
}

class _Button extends State<Button> {
  Color? myColor = Colors.grey[350];
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          // onTap: () {
          //   setState(() {
          //     myColor == Colors.grey[350]
          //         ? myColor = Colors.grey[500]
          //         : myColor = Colors.grey[350];
          //   });
          // },
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
                  Text(
                    widget.option,
                  ),
                ]),
              )),
        ));
  }
}
