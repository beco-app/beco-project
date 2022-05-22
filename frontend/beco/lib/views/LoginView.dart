import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:beco/globals.dart' as globals;

import '../Users.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int emailecode = 0;
  int passwordecode = 0;
  final GlobalKey<FormFieldState> emailKey = GlobalKey();
  final GlobalKey<FormFieldState> passwordKey = GlobalKey();
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  ...[
                    // Container(
                    //   height: 0,
                    // ),
                    const Spacer(),
                    Image.asset(
                      "assets/images/BECO_slogan-removebg.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      key: emailKey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if (emailecode == 1) {
                          emailecode = 0;
                          return "This user does not exist";
                        } else if (emailecode == 2) {
                          emailecode = 0;
                          return "Invalid email";
                        }
                        return null;
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      key: passwordKey,
                      controller: _password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        } else if (passwordecode == 1) {
                          return "Wrong password";
                        }
                        return null;
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              emailKey.currentState!.validate();
                              passwordKey.currentState!.validate();
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // final userid =
                              //     FirebaseAuth.instance.currentUser!.getIdToken();
                              // print(userid);

                              // Send user to backend
                              final r = await http.post(
                                  Uri.parse('http://34.252.26.132/'),
                                  body: {
                                    'username': email,
                                    'password': password,
                                  });

                              print(userCredential);
                              getUser().then((user) {
                                globals.user = user;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home/',
                                  (route) => false,
                                );
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'invalid-email' ||
                                  e.code == 'user-not-found') {
                                emailecode = 1;
                                emailKey.currentState!.validate();
                                print('Email 1');
                              } else if (e.code == 'wrong-password') {
                                passwordecode = 1;
                                passwordKey.currentState!.validate();
                                print('Email 2');
                              }
                              print("ERROR MESSAGE");
                              print(e);
                            }
                          },
                          child: const Text('Log In',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(184, 118, 185, 124),
                            onSurface: Colors.grey,
                          )),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/',
                            (route) => false,
                          );
                        },
                        child: const Text("No account? Create one!",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline)),
                        style: TextButton.styleFrom(
                            primary: const Color.fromARGB(184, 118, 185, 124),
                            backgroundColor: Colors.grey[50],
                            onSurface: Colors.grey,
                            elevation: 0),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
