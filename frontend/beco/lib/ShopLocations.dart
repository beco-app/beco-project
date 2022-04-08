import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'ShopLocations.g.dart';

// @JsonSerializable()
// class LatLong {
//   LatLong({
//     required this.lat,
//     required this.lng,
//   });

//   factory LatLong.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
//   Map<String, dynamic> toJson() => _$LatLngToJson(this);

//   final double lat;
//   final double lng;
// }

@JsonSerializable()
class Store {
  Store({
    required this.address,
    required this.id,
    // required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.region,
    required this.description,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);

  final String address;
  final String id;
  // final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String region;
  final String description;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.stores,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Store> stores;
}

Future<Locations> getStores() async {
  const shopLocationsURL = 'http://18.219.12.116/load_map';
  final voidStore = Store(
    address: "",
    id: "",
    // image: "https://theibizan.com/wp-content/uploads/2019/03/eco.jpg",
    lat: 0,
    lng: 0,
    name: "",
    phone: "",
    region: "",
    description: "",
  );
  final noStores = Locations(stores: [voidStore]);

  try {
    final response = await http.get(Uri.parse(shopLocationsURL));
    print("RESPONSE");
    log(response.body);
    if (response.statusCode == 200) {
      return Locations.fromJson(json.decode(response.body));
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
