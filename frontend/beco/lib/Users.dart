import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer';

part 'Users.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.zipcode,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  var id;
  var email;
  var password;
  var phone;
  var gender;
  var birthday;
  var zipcode;
  var preferences;
}

Future<User> getUser() async {
  const userinfoURL = 'http://34.252.26.132/user_info/';
  final voidUser = User(
    id: "",
    email: "",
    password: "",
    phone: "",
    gender: "",
    birthday: "",
    zipcode: "",
    preferences: [],
  );

  try {
    final response = await http.post(Uri.parse(userinfoURL),
        body: {"user_id": await FirebaseAuth.instance.currentUser!.uid});
    print("RESPONSE");
    log(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print("ERROR");
    print(e);
  }

  return voidUser;
}

// User reformatUser(User user) {
//   switch (user.gender) {
//     case "M":
//       user.gender = "Male";
//       break;
//     case "F":
//       user.gender = "Female";

//   }
//   return user;
// }
