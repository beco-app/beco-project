// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Discounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      id: json['_id']["\$oid"] as String,
      shopname: json['shopname']['shopname'] as String,
      shop_id: json['shop_id']["\$oid"] as String,
      description: json['description'] as String,
      becoins: json['becoins'] as int,
      // validInterval: json['valid_interval'] as String,
    );

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'id': instance.id,
      'shopname': instance.shopname,
      'shop_id': instance.shop_id,
      'description': instance.description,
      'becoins': instance.becoins,
      // 'valid_interval': instance.validInterval,
    };

Discounts _$DiscountsFromJson(Map<String, dynamic> json) => Discounts(
      discounts: (json['promotions'] as List<dynamic>)
          .map((e) => Discount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscountsToJson(Discounts instance) => <String, dynamic>{
      'discounts': instance.discounts,
    };
