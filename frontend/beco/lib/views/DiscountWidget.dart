import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:beco/Stores.dart';
import 'package:beco/tools/Discounts.dart';

import 'QRView.dart';

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
                                discount: snapshot.data!.discounts[i],
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
                            constraints: BoxConstraints(maxWidth: screenwidth*0.4, minWidth: screenwidth*0.4),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(width: screenwidth*0.1),

                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: screenwidth*0.3),
                            child: 
                          Row(children: [
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
                            constraints: BoxConstraints(maxWidth: screenwidth*0.8),
                            child:
                        Row(
                          children: [
                          Spacer(),
                          Button(option: "Redeem"),
                          Spacer(),
                          Button(option: "Unsave"),
                          Spacer(),
                          Button(option: "Go to shop"),
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
          child: Container(
              //Button config
              decoration: BoxDecoration(
                color:
                    myColor,
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
          child: Container(
              //Button config
              decoration: BoxDecoration(
                color:
                    myColor,
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

showAlertDialog(BuildContext context, Discount discount) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.pushNamed(
                  context,
                  QRView.routeName,
                  arguments: discount,
                  ); 
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure you want to use this discount?"),
    content: Text("It costs ${discount.becoins.toString()} becoins"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
