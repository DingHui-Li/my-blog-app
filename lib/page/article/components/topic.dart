import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_blog_app/model/article.dart';

class TopicBtn extends StatelessWidget {
  Topic data;
  TopicBtn({Key? key, required this.data}) : super(key: key);

  static const List<int> colors = [
    0xffC8E3F9,
    0xffFFEAC9,
    0xffFFD6D9,
    0xffC8E6C9,
    0xffFFEFC1,
    0xffDACFEC,
    0xffE7E0DE,
    0xffEAEAEB,
  ];

  @override
  Widget build(BuildContext context) {
    int random = Random().nextInt(colors.length - 1);
    return CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
              color: Color(colors[random]),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Text(
            data.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
        onPressed: () {});
  }
}
