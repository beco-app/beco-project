import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                      "assets/images/logo.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    TextField(
                      controller: _email,
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
                    TextField(
                      controller: _password,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
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
                                Uri.parse('http://18.219.12.116/'),
                                body: {
                                  'username': email,
                                  'password': password,
                                });

                            print(userCredential);

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home/',
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e.code);
                          }
                        },
                        child: const Text('Log In',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // style: TextButton.styleFrom(
                        //   primary: Colors.white,
                        //   backgroundColor: Colors.purple[800],
                        //   onSurface: Colors.grey,
                        //)
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/',
                            (route) => false,
                          );
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // style: TextButton.styleFrom(
                        //   primary: Colors.white,
                        //   backgroundColor: Colors.purple[800],
                        //   onSurface: Colors.grey,
                        // ),
                      ),
                    )
                  ].expand(
                    (widget) => [
                      widget,
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
