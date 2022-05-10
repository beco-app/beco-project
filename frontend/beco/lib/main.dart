import 'dart:collection';
import 'package:beco/Users.dart';
import 'package:beco/views/DetailView.dart';
import 'package:beco/views/HomeView.dart';
import 'package:beco/views/LoginView.dart';
import 'package:beco/views/RegisterView.dart';
import 'package:beco/views/QRView.dart';
import 'package:beco/views/VerifyEmailView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Stores.dart';
import 'firebase_options.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple[900]),
      home: const HomeView(), // Page shown when app is started.
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomeView(),
        DetailView.routeName: (context) => const DetailView(),
        QRView.routeName: (context) => const QRView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stores storeList;
  @override
  void initState() {
    super.initState();
    _initStores();
    _initUser();
  }

  void _initStores() async {
    globals.storeList = await getStores();
    FlutterNativeSplash.remove();
  }

  void _initUser() async {
    globals.user = await getUser();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              // if (user.emailVerified) {
              //   print('Email is verified');
              // } else {
              //   return const VerifyEmailView();
              // }
              return const HomeView();
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
