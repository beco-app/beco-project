import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomepageWidget extends StatefulWidget {
  @override
  _HomepageWidgetState createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator HomepageWidget - FRAME

    return Container(
        width: 360,
        height: 800,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 199,
              left: 4,
              child: Container(
                  width: 353,
                  height: 864,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 353,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/background2.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Bodevici',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Ice cream shop',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 272,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 79,
                                  left: 17,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 150,
                        left: 353,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/background1.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Flax & Kale',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Healthy restaurant',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 272,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 76,
                                  left: 17,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 592,
                        left: 353,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/background1.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Flax & Kale',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Healthy restaurant',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 272,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 77,
                                  left: 16,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 446,
                        left: 353,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/background2.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Bodevici',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Ice cream shop',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 272,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 79,
                                  left: 17,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 300,
                        left: 352,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 15,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/background3.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Teresa Carles',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Healthy foods',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 271,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 76,
                                  left: 15,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 738,
                        left: 353,
                        child: Container(
                            width: 352,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(255, 251, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                width: 1,
                              ),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 16,
                                  left: 15,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/Background.png'),
                                                            fit: BoxFit
                                                                .fitWidth),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        40,
                                                                        40)),
                                                      ))),
                                            ])),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Teresa Carles',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0.10000000149011612,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.5),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Healthy foods',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        28, 27, 31, 1),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    letterSpacing: 0.25,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.4285714285714286),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 271,
                                  child: Container(
                                      width: 80,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Media.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[]))),
                              Positioned(
                                  top: 76,
                                  left: 16,
                                  child: Container(
                                      width: 110.9998779296875,
                                      height: 37,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Naturalfood.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 37.000125885009766,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/Nogluten.png'),
                                                      fit: BoxFit.fitWidth),
                                                ))),
                                        Positioned(
                                            top: -2.842170943040401e-14,
                                            left: 73.9998779296875,
                                            child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 3.0833334922790527,
                                                      left: 15.416666030883789,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                  Positioned(
                                                      top: 10.809103012084961,
                                                      left: 7.7083330154418945,
                                                      child: SvgPicture.asset(
                                                          'assets/images/vector.svg',
                                                          semanticsLabel:
                                                              'vector')),
                                                ]))),
                                      ]))),
                            ]))),
                  ]))),
          Positioned(
              top: 76,
              left: 334,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                  color: Color.fromRGBO(232, 222, 248, 0.5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/vector.svg',
                        semanticsLabel: 'vector'),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Search',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(29, 25, 43, 1),
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                letterSpacing: 0.10000000149011612,
                                fontWeight: FontWeight.normal,
                                height: 1.4285714285714286),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 720,
              left: 420,
              child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Name.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 147,
              left: 344,
              child: Container(
                  width: 405,
                  height: 37,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            color:
                                Color.fromRGBO(31, 31, 31, 0.11999999731779099),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Naturalfood.png'),
                                                  fit: BoxFit.fitWidth),
                                            ))),
                                  ])),
                              SizedBox(width: 12),
                              Text(
                                'Veggie',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        31, 31, 31, 0.3799999952316284),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    letterSpacing: 0.10000000149011612,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        top: 0,
                        left: -123,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            color:
                                Color.fromRGBO(31, 31, 31, 0.11999999731779099),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Nogluten.png'),
                                                  fit: BoxFit.fitWidth),
                                            ))),
                                  ])),
                              SizedBox(width: 12),
                              Text(
                                'No gluten',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        31, 31, 31, 0.3799999952316284),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    letterSpacing: 0.10000000149011612,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        top: 1,
                        left: -263,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            color:
                                Color.fromRGBO(31, 31, 31, 0.11999999731779099),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                            child: Stack(children: <Widget>[
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: SvgPicture.asset(
                                                      'assets/images/vector.svg',
                                                      semanticsLabel:
                                                          'vector')),
                                              Positioned(
                                                  top: 2,
                                                  left: 10,
                                                  child: SvgPicture.asset(
                                                      'assets/images/vector.svg',
                                                      semanticsLabel:
                                                          'vector')),
                                              Positioned(
                                                  top: 7.01131010055542,
                                                  left: 5,
                                                  child: SvgPicture.asset(
                                                      'assets/images/vector.svg',
                                                      semanticsLabel:
                                                          'vector')),
                                            ]))),
                                  ])),
                              SizedBox(width: 12),
                              Text(
                                'Accessible',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        31, 31, 31, 0.3799999952316284),
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    letterSpacing: 0.10000000149011612,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ],
                          ),
                        )),
                  ])))
          // ),Positioned(
          //   top: 0,
          //   left: 0,
          //   child: null
          // ),Positioned(
          //   top: 720,
          //   left: 360,
          //   child: null
          // ),
        ]));
  }
}
