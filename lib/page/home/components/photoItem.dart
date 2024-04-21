import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/components/zoomOutPress.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/home/PhotoDetail.dart';

// ignore: must_be_immutable
class PhotoItem extends StatelessWidget {
  List<Article> list;
  bool isFirst;
  PhotoItem({Key? key, required this.list, this.isFirst = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Article> imgs = {};
    for (Article item in list) {
      for (String img in item.imgs) {
        imgs[img] = item;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isFirst
            ? Text(
                Moment(list[0].createTimeObj).format('LLLL'),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              )
            : const SizedBox(),
        Text(
          Moment(list[0].createTimeObj).fromNowPrecise(),
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 5),
        isFirst ? comPhotosOfFirst(imgs) : comPhotos(imgs),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget comPhotosOfFirst(Map<String, Article> imgs) {
    List<String> imgList = imgs.keys.toList();
    return Column(
      children: imgList.asMap().keys.map<Widget>((index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: AspectRatio(
            aspectRatio: index == 0 ? 3 / 4 : 2 / 1,
            child: comImg(imgList[index], radius: const Radius.circular(20)),
          ),
        );
      }).toList(),
    );
  }

  Widget comPhotos(Map<String, Article> imgs) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      padding: const EdgeInsets.only(top: 5),
      children: imgs.keys.map<Widget>((img) {
        return comImg(img);
      }).toList(),
    );
  }

  Widget comImg(String src, {Radius radius = const Radius.circular(6)}) {
    Widget imgEl = Hero(
        tag: '${src}ofPhotoPage',
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: const Color(0xffeeeeee),
            borderRadius: BorderRadius.all(radius),
          ),
          child: CachedNetworkImage(
            imageUrl: MyBlog.getThumb(src, size: 500),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            // gaplessPlayback: true,
          ),
        ));
    return ZoomOutPress(
        child: imgEl,
        onPress: () {
          Get.to(
            () => PhotoDetailPage(list: list),
            duration: const Duration(milliseconds: 500),
          );
        });
  }
}
