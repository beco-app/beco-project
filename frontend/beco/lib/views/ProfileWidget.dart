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
    return CustomScrollView(
        slivers: [
          SliverAppBar( //maybe sliverpersistentheader is better
            floating: false,
            expandedHeight: 150,
            flexibleSpace: 
            Container(
              //child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                child:  
                  Material(
                  shape: CircleBorder(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                        "assets/images/logo.png",
                        width: 150, //s'ha de fer fit
                        //fit: BoxFit.cover,
                      )
                    )
                  ),
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
              child: Column(
                children:[ 
                  TextField(
                      controller: null,
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
                    SizedBox(height: 2000),
                ]
              )
            )
          )
        ]
    );
  }
}