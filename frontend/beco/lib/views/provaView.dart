import 'package:beco/views/HomeWidget.dart';
import 'package:flutter/material.dart';

class provaWidget extends StatefulWidget {
  const provaWidget({Key? key}) : super(key: key);

  @override
  State<provaWidget> createState() => _provaWidgetState();
}

class _provaWidgetState extends State<provaWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconsRow(),
          SizedBox(
            height: 2000,
          ),
          Text("Hola"),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(actions: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    height: 100.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100.0,
                          child: Card(
                            child: Text('data'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
