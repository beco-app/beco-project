import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'Stores.g.dart';

@JsonSerializable()
class Store {
  Store({
    required this.id,
    required this.address,
    required this.shopname,
    required this.lat,
    required this.lng,
    required this.neighbourhood,
    required this.description,
    required this.photo,
    required this.type,
    required this.tags,
    required this.web,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);

  final String id;
  final String address;
  final String shopname;
  final double lat;
  final double lng;
  final String neighbourhood;
  final String description;
  final String photo;
  final String type;
  final List tags;
  final String web;
}

@JsonSerializable()
class Stores {
  Stores({
    required this.stores,
  });

  factory Stores.fromJson(Map<String, dynamic> json) => _$StoresFromJson(json);
  Map<String, dynamic> toJson() => _$StoresToJson(this);

  final List<Store> stores;
}

Future<Stores> getMapStores() async {
  const shopLocationsURL = 'http://18.219.12.116/load_map';
  final voidStore = Store(
    id: "",
    address: "",
    shopname: "",
    lat: 0,
    lng: 0,
    neighbourhood: "",
    description: "",
    photo: "https://theibizan.com/wp-content/uploads/2019/03/eco.jpg",
    type: "",
    tags: [],
    web: "",
  );
  final noStores = Stores(stores: [voidStore]);

  try {
    final response = await http.get(Uri.parse(shopLocationsURL));
    print("RESPONSE");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      return Stores.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print("ERROR");
    print(e);
  }

  return noStores;

  // // Fallback for when the above HTTP request fails.
  // return Locations.fromJson(
  //   json.decode(
  //     await rootBundle.loadString('assets/locations.json'),
  //   ),
  // );
}

Future<Stores> getHomepageStores() async {
  const shopButtonsURL = 'http://18.219.12.116/homepage';
  final voidStore = Store(
    id: "",
    address: "",
    shopname: "",
    lat: 0,
    lng: 0,
    neighbourhood: "",
    description: "",
    photo: "https://theibizan.com/wp-content/uploads/2019/03/eco.jpg",
    type: "",
    tags: [],
    web: "",
  );
  final noStores = Stores(stores: [voidStore]);

  try {
    final response = await http.get(Uri.parse(shopButtonsURL));
    print(response);
    print("RESPONSE");
    log(response.body);
    if (response.statusCode == 200) {
      return Stores.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print("ERROR");
    print(e);
  }

  return noStores;
}
