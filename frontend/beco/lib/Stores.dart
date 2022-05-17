import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

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
    required this.aqi,
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
  final double aqi;
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

Future<List<double>> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return [-1, -1];
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return [-1, -1];
  }

  Position position = await Geolocator.getCurrentPosition();

  return [position.latitude, position.longitude];
}

Future<Stores> getMapStores() async {
  const shopLocationsURL = 'http://34.252.26.132/load_map';
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
    aqi: 0,
  );
  final noStores = Stores(stores: [voidStore]);

  try {
    final response = await http.get(Uri.parse(shopLocationsURL));
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
  print("This is the position of the user.");
  final position = await _determinePosition();
  print("This is the position of the user.");
  print(position[0]);
  print(position[1]);
  const shopButtonsURL = 'http://34.252.26.132/recommended_shops/';
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
    aqi: 0,
  );
  final noStores = Stores(stores: [voidStore]);

  try {
    final response = await http.post(Uri.parse(shopButtonsURL), body: {
      "user_id": await FirebaseAuth.instance.currentUser!.uid,
      "user_lat": position[0] == -1 ? '' : position[0].toString(),
      "user_lon": position[1] == -1 ? '' : position[1].toString()
    });

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

Future<Store> getStore(String storeId) async {
  const shopURL = 'http://34.252.26.132/shop_info';
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
    aqi: 0,
  );

  try {
    final response =
        await http.post(Uri.parse(shopURL), body: {"shop_id": storeId});
    print("RESPONSE");
    log(response.body);
    if (response.statusCode == 200) {
      print(Store.fromJson(json.decode(response.body)));
      return Store.fromJson(json.decode(response.body));
    }
  } catch (error) {
    print(error);
  }
  return voidStore;
}
