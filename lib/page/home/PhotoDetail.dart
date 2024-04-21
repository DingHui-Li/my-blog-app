import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/components/zoomOutPress.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/home/components/topic.dart';
import 'package:my_blog_app/page/photoView.dart';

// ignore: must_be_immutable
class PhotoDetailPage extends StatelessWidget {
  List<Article> list;
  PhotoDetailPage({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        middle: Text(
          Moment(list[0].createTimeObj).format('YYYY/MM/DD'),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: DismissiblePage(
        backgroundColor: Colors.white,
        direction: DismissiblePageDismissDirection.down,
        onDismissed: () {
          Get.back();
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 100, 15, 30),
          children: list
              .asMap()
              .entries
              .map(
                (e) => articleItem(
                  e.value,
                  showDivider: e.key != (list.length - 1),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget articleItem(Article article, {bool showDivider = true}) {
    String weatherStr = article.weather['text'] != null
        ? '${article.weather['text']}.${article.weather['temp']}℃'
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...article.imgs.asMap().entries.map((entry) {
          int index = entry.key;
          String img = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ZoomOutPress(
              child: Hero(
                tag: '${img}ofPhotoPage',
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: MyBlog.getThumb(img, size: 500),
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              onPress: () {
                Get.to(
                    () => PhotoView(
                          index: index,
                          imgs: article.imgs,
                          heroTag: 'ofPhotoPage',
                        ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
            ),
          );
        }).toList(),
        Text(
          article.textContent,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${Moment(article.createTimeObj).format('LLLL')}.${article.location.name}.${weatherStr}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        Wrap(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: article.topics
              .map<Widget>((Topic item) => ComTopic(data: item))
              .toList(),
        ),
        const SizedBox(height: 15),
        showDivider
            ? Divider(
                color: Colors.black.withOpacity(0.1),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }
}
