import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'Discounts.g.dart';

@JsonSerializable()
class Discount {
  Discount({
    required this.id,
    required this.shopname,
    required this.shop_id,
    required this.description,
    required this.becoins,
    // required this.validInterval,
  });

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);

  final String id;
  final String shopname;
  final String shop_id;
  final String description;
  final int becoins;
  // final String validInterval; // TODO: Canviar a datetime o format apropiat
}

@JsonSerializable()
class Discounts {
  Discounts({
    required this.discounts,
  });

  factory Discounts.fromJson(Map<String, dynamic> json) =>
      _$DiscountsFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountsToJson(this);

  final List<Discount> discounts;
}

Future<Discounts> getDiscounts() async {
  const discountsURL = 'http://34.252.26.132/promotions/saved';
  final voidDiscount = Discount(
    id: "",
    shopname: "",
    shop_id: "",
    description: "",
    becoins: 0,
    // validInterval: "",
  );
  final noDiscount = Discounts(discounts: [voidDiscount]);

  try {
    // final response = await http.post(Uri.parse(discountsURL),
    // body: {"user_id": await FirebaseAuth.instance.currentUser!.uid});
    final response = await http.post(Uri.parse(discountsURL),
        body: {"user_id": await FirebaseAuth.instance.currentUser!.uid});
    print("RESPONSE");
    print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print(Discounts.fromJson(json.decode(response.body)));
      return Discounts.fromJson(json.decode(response.body));
    }
  } catch (err) {
    print("ERROR");
    print(err);
  }

  return noDiscount;
}
