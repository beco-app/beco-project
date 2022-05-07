import 'package:beco/views/MapWidget.dart';
import 'package:beco/views/ProfileWidget.dart';
import 'package:beco/views/provaView.dart';
import 'package:flutter/material.dart';
import 'package:beco/views/HomeWidget.dart';
import 'package:beco/views/DiscountWidget.dart';
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
    MapWidget(),
    DiscountWidget(),
    ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.only(left: 5, bottom: 8),
            alignment: Alignment.centerLeft,
            //decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30),
            //border: Border.all(
            //color: Color.fromARGB(255, 41, 41, 41), width: 1.2)),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  child: Image.asset('assets/images/becoin.png',
                      height: kToolbarHeight * 0.5),
                  alignment: Alignment.bottomLeft),
              const SizedBox(width: 5),
              Container(
                  width: screenwidth * 0.22,
                  child: Text(
                    '1930dfdf', //canviar
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 24, color: Color.fromARGB(255, 41, 41, 41)),
                  ),
                  alignment: Alignment.bottomLeft),
            ])),
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/BECO_nom-removebg-preview 1.png',
              height: kToolbarHeight * 0.6),
        ]),
        backgroundColor: Color.fromARGB(255, 235, 228, 233),
        elevation: 0.0,
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
