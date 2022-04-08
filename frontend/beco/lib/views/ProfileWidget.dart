import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
          //maybe sliverpersistentheader is better
          floating: false,
          expandedHeight: 150,
          flexibleSpace: Container(
              //child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              child: Stack(children: [
            Positioned.fill(
                child: Image.asset("assets/images/media_4.png",
                    fit: BoxFit.cover)),
            Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 150, //s'ha de fer fit
                          //fit: BoxFit.cover,
                        )))),
          ])

              //  Text("username")

              //)
              )
          // flexibleSpaceBar(
          //  background: Image.asset(
          //           "assets/images/logo.png",
          //           fit: BoxFit.cover,
          // )
          // bottom: PreferredSize(
          //     preferredSize: const Size.fromHeight(0.0),
          //     child: Material(
          //       shape: CircleBorder(),
          //       clipBehavior: Clip.antiAliasWithSaveLayer,
          //       child: InkWell(
          //         onTap: () {},
          //         child: Image.asset(
          //             "assets/images/logo.png",
          //             width: 150, //s'ha de fer fit
          //             fit: BoxFit.cover,
          //           )
          //         )
          //       ),
          //     ),
          ),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(children: [
                InfoContainer(attribute: 'Username', content: 'm.garcia'),
                SizedBox(height: 20),
                InfoContainer(
                    attribute: 'Mail',
                    content: 'martag@gmail.com'), //TO DO: Check length
                SizedBox(height: 20),
                InfoContainer(attribute: 'Phone', content: '+34 999 999 999'),
                SizedBox(height: 20),
                InfoContainer(attribute: 'Zipcode', content: '62954'),
                SizedBox(height: 20),
                InfoContainer(
                    attribute: 'Diet',
                    content: 'No preference'), //WHEN THERES TIME: Able changes
                SizedBox(height: 20),
                InfoContainer(attribute: 'Gender', content: 'Woman'),
                SizedBox(height: 20),
                InfoContainer(attribute: 'Birthday', content: '31/12/1999')
              ])))
    ]);
  }
}

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    required this.attribute,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String attribute;
  final String content;

  @override
  Widget build(context) {
    return Container(
        padding: const EdgeInsets.only(left: 30.0),
        height: 55,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: Color.fromRGBO(217, 195, 220, 0.584),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          Container(
              width: 105,
              child: Text(attribute, style: TextStyle(fontSize: 17))),
          Container(
            width: 300,
            height: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]));
  }
}
