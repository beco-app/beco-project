import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beco/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
        title: const Text('Map'),
        // backgroundColor: Colors.purple[800],
      ),
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
