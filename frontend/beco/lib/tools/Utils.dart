import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:beco/Stores.dart';
import 'package:beco/tools/Discounts.dart';

/*
  FITXER ON GUARDEM ELS WIDGETS COM BOTONS I COSES NO PRINCIPALS
*/

// Unsave button
class SaveButton extends StatefulWidget {
  const SaveButton({required this.userId, required this.discountId, Key? key})
      : super(key: key);

  final String userId;
  final String discountId;

  @override
  State<SaveButton> createState() => _SaveButton();
}

class _SaveButton extends State<SaveButton> {
  Color? myColor = Colors.grey[350];
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () async {
            final r = await http
                .post(Uri.parse('http://34.252.26.132/promotions/save'), body: {
              'user_id': widget.userId,
              'promotion_id': widget.discountId,
            });
            saveAlert(context);
            setState(() {});
          },
          child: Container(
              //Button config
              decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(// Everything inside the button
                    children: [
                  Text(
                    "Save",
                  ),
                ]),
              )),
        ));
  }
}

saveAlert(BuildContext context) {
  // set up the buttons
  Widget okay = TextButton(
    child: const Text("Done"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: const Text("Are you sure you want to use this discount?"),
    content: Text("Discount saved."),
    actions: [okay],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// Unsave button
class UnsaveButton extends StatefulWidget {
  const UnsaveButton({required this.userId, required this.discountId, Key? key})
      : super(key: key);

  final String userId;
  final String discountId;

  @override
  State<UnsaveButton> createState() => _UnsaveButton();
}

class _UnsaveButton extends State<UnsaveButton> {
  Color? myColor = Colors.grey[350];
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () async {
            final r = await http.post(
                Uri.parse('http://34.252.26.132/promotions/unsave'),
                body: {
                  'user_id': widget.userId,
                  'promotion_id': widget.discountId,
                });
            unsaveAlert(context);
            setState(() {});
          },
          child: Container(
              //Button config
              decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(// Everything inside the button
                    children: [
                  Text(
                    "Unsave",
                  ),
                ]),
              )),
        ));
  }
}

unsaveAlert(BuildContext context) {
  // set up the buttons
  Widget okay = TextButton(
    child: const Text("Done"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: const Text("Are you sure you want to use this discount?"),
    content: Text("Discount unsaved."),
    actions: [okay],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
