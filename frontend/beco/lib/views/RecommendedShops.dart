import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'RecommendedShops.g.dart';

@JsonSerializable()
class HomepageStore {
  HomepageStore({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.tags,
    required this.type,
  });

  factory HomepageStore.fromJson(Map<String, dynamic> json) =>
      _$HomepageStoreFromJson(json);
  Map<String, dynamic> toJson() => _$HomepageStoreToJson(this);

  final String id;
  final String image;
  final String name;
  final String description;
  final List tags;
  final String type;
}

@JsonSerializable()
class Shops {
  Shops({
    required this.stores,
  });

  factory Shops.fromJson(Map<String, dynamic> json) => _$ShopsFromJson(json);
  Map<String, dynamic> toJson() => _$ShopsToJson(this);

  final List<HomepageStore> stores;
}

Future<Shops> getHomepageStores() async {
  const shopButtonsURL = 'http://18.219.12.116/homepage';
  final voidStore = HomepageStore(
    id: "",
    image: "https://theibizan.com/wp-content/uploads/2019/03/eco.jpg",
    name: "",
    description: "",
    tags: [],
    type: "",
  );
  final noStores = Shops(stores: [voidStore]);

  try {
    final response = await http.get(Uri.parse(shopButtonsURL));
    print("RESPONSE");
    log(response.body);
    if (response.statusCode == 200) {
      return Shops.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print("ERROR");
    print(e);
  }

  return noStores;
}
