import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'Users.g.dart';

@JsonSerializable()
class ProfileUser {
  ProfileUser({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.zipcode,
    required this.preferences,
    required this.becoins,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  late String id;
  late String email;
  late String password;
  late String phone;
  late String gender;
  late String birthday;
  late String zipcode;
  late List<String> preferences;
  late int becoins;
}

Future<ProfileUser> getUser() async {
  const userinfoURL = 'http://34.252.26.132/user_info/';
  final voidUser = ProfileUser(
    id: "",
    email: "",
    password: "",
    phone: "",
    gender: "",
    birthday: "",
    zipcode: "",
    preferences: [],
    becoins: 0,
  );
  late final ProfileUser user;

  try {
    final response = await http.post(Uri.parse(userinfoURL),
        body: {"user_id": await FirebaseAuth.instance.currentUser!.uid});
    print("RESPONSE user");
    log(response.body);
    if (response.statusCode == 200) {
      print("hola");
      user = ProfileUser.fromJson(json.decode(response.body));
      print(user);
      return user;
    }
  } catch (e) {
    print("ERROR");
    print(e);
  }

  return voidUser;
}
