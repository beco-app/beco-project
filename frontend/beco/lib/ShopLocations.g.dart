// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShopLocations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      address: json['address'] as String,
      id: json['id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
      region: json['region'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'region': instance.region,
      'description': instance.description,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'stores': instance.stores,
    };
