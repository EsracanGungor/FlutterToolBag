import 'package:flutter/material.dart';
AppBar headerNav(BuildContext context, String title){
  return AppBar(
    shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(bottom: Radius.circular(60))),
    centerTitle: true,
    backgroundColor:Theme.of(context).primaryColor,
    title: Text(title),
  );
}