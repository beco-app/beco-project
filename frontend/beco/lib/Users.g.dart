// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      birthday: json['birthday'] as String,
      zipcode: json['zipcode'] as String,
      preferences: json['preferences'] as List<dynamic>,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'zipcode': instance.zipcode,
      'preferences': instance.preferences,
    };
