import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_blog_app/model/article.dart';

// ignore: must_be_immutable
class ComTopic extends StatelessWidget {
  Topic data;
  ComTopic({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(data);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10, bottom: 2, top: 2),
        child: Text(
          '#' + data.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xff3f51b5),
          ),
        ),
      ),
    );
  }
}
