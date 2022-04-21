import 'package:beco/Stores.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    required this.store,
    Key? key,
  }) : super(key: key);

  final Store store;

//   @override
//   State<DetailView> createState() => _DetailViewState();
// }

// class _DetailViewState extends State<DetailView> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BECO'),
        ),
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  //Image.network(widget.store.image),
                  Text("hola"),
                ],
              ))
        ]));
  }
}
