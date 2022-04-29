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
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<Discounts>(
                future: discountList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var i = 0; i < 1; i++)
                          Column(
                            children: [
                              Button(
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

List<String> options = ['Active', 'Saved', 'Recommended'];

class Button extends StatelessWidget {
  const Button({
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
                        Text(shopName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 5),
                        Text(
                          description,
                        ),
                        SizedBox(height: 10),
                      ]),
                  const Spacer(),
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
            for (var word in options)
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
                                Text(
                                  word,
                                ),
                              ]),
                            ))))
              ]),
            SizedBox(width: 20),
          ],
        ));
  }
}
