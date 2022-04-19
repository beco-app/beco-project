// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecommendedShops.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomepageStore _$HomepageStoreFromJson(Map<String, dynamic> json) =>
    HomepageStore(
      address: json['address'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tags: json['tags'] as List<dynamic>,
      type: json['type'] as String,
    );

Map<String, dynamic> _$HomepageStoreToJson(HomepageStore instance) =>
    <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'type': instance.type,
    };

Shops _$ShopsFromJson(Map<String, dynamic> json) => Shops(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => HomepageStore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopsToJson(Shops instance) => <String, dynamic>{
      'stores': instance.stores,
    };
