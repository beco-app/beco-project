import 'dart:collection';
import 'package:beco/Users.dart';
import 'package:beco/views/DetailView.dart';
import 'package:beco/views/DiscountWidget.dart';
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

bool loading = true;

void main() async {
  // await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple[900]),
      home: const HomePage(), // Page shown when app is started.
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => HomeView(selectedIndex: 0),
        DetailView.routeName: (context) => const DetailView(),
        QRView.routeName: (context) => const QRView(),
        '/discounts/': (context) => HomeView(selectedIndex: 2),
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
    //Firebase.initializeApp();
  }

  void _initStores() async {
    globals.storeList = await getMapStores();
  }

  void _initUser() async {
    globals.user = await getUser();
    //FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   ),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    if (loading) {
      getMapStores().then((storeList) {
        globals.storeList = storeList;
        getUser().then((user) {
          globals.user = user;
          setState(() {
            loading = false;
          });
        });
      });
      return CircularProgressIndicator();
    } else {
      FlutterNativeSplash.remove();
      final user = FirebaseAuth.instance.currentUser;
      print(user);
      if (user != null) {
        // if (user.emailVerified) {
        //   print('Email is verified');
        // } else {
        //   return const VerifyEmailView();
        // }
        return HomeView(selectedIndex: 0);
      } else {
        return const LoginView();
      }
    }
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );
  }
}
