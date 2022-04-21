// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Stores.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: json['_id']["\$oid"] as String,
      address: json['address'] as String,
      shopname: json['shopname'] as String,
      lat: (json['location'][0] as num).toDouble(),
      lng: (json['location'][1] as num).toDouble(),
      neighbourhood: json['neighbourhood'] as String,
      description: json['description'] as String,
      photo: json['photo'] as String,
      type: json['type'] as String,
      tags: json['tags'] as List<dynamic>,
      web: json['web'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'shopname': instance.shopname,
      'lat': instance.lat,
      'lng': instance.lng,
      'neighbourhood': instance.neighbourhood,
      'description': instance.description,
      'photo': instance.photo,
      'type': instance.type,
      'tags': instance.tags,
      'web': instance.web,
    };

Stores _$StoresFromJson(Map<String, dynamic> json) => Stores(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoresToJson(Stores instance) => <String, dynamic>{
      'stores': instance.stores,
    };
