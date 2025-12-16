import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text),),);
}
