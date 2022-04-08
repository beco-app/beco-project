import 'package:beco/views/MapWidget.dart';
import 'package:beco/views/ProfileWidget.dart';
import 'package:flutter/material.dart';
import 'package:beco/views/HomeWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_textfield_search/search.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final views = ['/home/', '/map/', '/discounts/', '/profile/'];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _pages = <Widget>[
    HomeWidget(),
    Icon(
      Icons.camera,
      size: 150,
    ),
    MapWidget(),
    Icon(
      Icons.chat,
      size: 150,
    ),
    ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('BECO'),
        // backgroundColor: Colors.purple[800],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.house, color: Colors.black),
              label: 'Home',
              activeIcon: Icon(Icons.house, color: Colors.deepPurple)),
          BottomNavigationBarItem(
              icon: Icon(Icons.map, color: Colors.black),
              label: 'Map',
              activeIcon: Icon(Icons.map, color: Colors.deepPurple)),
          BottomNavigationBarItem(
              icon: Icon(Icons.price_check, color: Colors.black),
              label: 'Discounts',
              activeIcon: Icon(Icons.price_check, color: Colors.deepPurple)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp, color: Colors.black),
              label: 'Profile',
              activeIcon:
                  Icon(Icons.account_circle_sharp, color: Colors.deepPurple)),
        ],
      ),
    );
  }
}
