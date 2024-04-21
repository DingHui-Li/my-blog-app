import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/article/content.dart';
import 'package:my_blog_app/page/home/components/topic.dart';

class ArtticleItem extends StatelessWidget {
  Article data;
  ArtticleItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...data.topics
                      .map<Widget>((Topic item) => ComTopic(data: item))
                      .toList(),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                Moment(data.createTimeObj).fromNow(),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff999999),
                ),
              )
              // Text(
              //   data.textContent,
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: Color(0xff333333),
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // )
            ],
          ),
        ),
        const SizedBox(width: 6),
        data.cover != ""
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(data.cover, size: 200),
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              )
            : const SizedBox()
      ],
    );
    // return CupertinoButton(
    //   onPressed: () {
    //     Get.to(
    //       ArticleContent(data: data),
    //       duration: const Duration(
    //         milliseconds: 600,
    //       ),
    //       transition: Transition.cupertino,
    //       curve: Curves.linear,
    //     );
    //   },
    //   padding: EdgeInsets.all(0),
    //   child:content,
    // );
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 500),
      openElevation: 0,
      closedElevation: 0,
      closedBuilder: (BuildContext _, VoidCallback openContainer) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: content,
      ),
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ArticleContentPage(data: data);
      },
    );
  }
}
