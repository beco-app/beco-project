import 'package:beco/Stores.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailView extends StatelessWidget {
  const DetailView({ Key? key,}) : super(key: key);
  static const routeName = '/detail/';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store;
    return CustomScrollView(slivers: [
      SliverAppBar(
          //maybe sliverpersistentheader is better
          floating: false,
          expandedHeight: 150,
          flexibleSpace:
              //child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              Stack(children: [
            Positioned.fill(
                child: Image.asset("assets/images/media_4.png",
                    fit: BoxFit.cover)),
            Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                        onTap: () {},
                        child: Image.network(
                          args.photo,
                          width: 150,
                          height: 150, //s'ha de fer fit
                          fit: BoxFit.cover,
                        )
                      )
                    )
                  ),
          ])),
      SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Text(
                  args.shopname,
                  style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)
                ),
                Text(
                  args.type,
                  style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)
                ),
                Text(
                  args.description,
                  style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)
                ),
                const SizedBox(height: 2000)
              ])))
    ]);
  }
  }
