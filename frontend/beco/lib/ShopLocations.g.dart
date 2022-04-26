// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShopLocations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// LatLong _$LatLngFromJson(Map<String, dynamic> json) => LatLong(
//       lat: (json['lat'] as num).toDouble(),
//       lng: (json['lng'] as num).toDouble(),
//     );

// Map<String, dynamic> _$LatLngToJson(LatLong instance) => <String, dynamic>{
//       'lat': instance.lat,
//       'lng': instance.lng,
//     };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      address: json['address'] as String,
      id: json['_id']["\$oid"] as String,
      // image: json['image'] as String,
      lat: (json['location'][0] as num).toDouble(),
      lng: (json['location'][1] as num).toDouble(),
      name: json['shopname'] as String,
      // phone: json['phone'] as String,
      region: json['neighbourhood'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      // 'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      // 'phone': instance.phone,
      'region': instance.region,
      'description': instance.description,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      stores: (json['shops'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'stores': instance.stores,
    };
