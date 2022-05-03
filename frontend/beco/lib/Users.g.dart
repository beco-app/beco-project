// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileUser _$UserFromJson(Map<String, dynamic> json) => ProfileUser(
      id: json['_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      birthday: json['birthday'] as String,
      zipcode: json['zip_code'] as String,
      preferences: json['preferences'].cast<String>() as List<String>,
    );

Map<String, dynamic> _$UserToJson(ProfileUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'zipcode': instance.zipcode,
      'preferences': instance.preferences.toString(),
    };
