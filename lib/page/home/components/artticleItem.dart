import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/home/components/topic.dart';

class ArtticleItem extends StatelessWidget {
  Article data;
  ArtticleItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        print('tap');
      },
      padding: EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...data.topics
                        .map<Widget>((Topic item) => ComTopic(data: item))
                        .toList(),
                    Text(
                      '5天前',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff999999),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  data.textContent,
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SizedBox(width: 6),
          data.cover != ""
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Image.network(
                    data.cover,
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
