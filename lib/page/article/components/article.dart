import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/components/zoomOutPress.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/article/content.dart';

class ArticleCard extends StatelessWidget {
  Article data;
  double aspectRatio;
  ArticleCard({Key? key, required this.data, this.aspectRatio = 4 / 5})
      : super(key: key);
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
    double width = MediaQuery.of(context).size.width;
    Widget content = Stack(
      children: [
        // BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //   child: Container(
        //     color: Colors.white.withOpacity(0.1),
        //   ),
        // ),
        //cover
        data.cover != ''
            ? CachedNetworkImage(
                imageUrl: MyBlog.getThumb(data.cover, size: 500),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            : const SizedBox(),
        //mask
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.8),
                Colors.transparent,
              ],
            ),
          ),
          //title
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                Moment(data.createTimeObj).fromNow(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 500),
      openElevation: 0,
      closedElevation: 0,
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      closedBuilder: (BuildContext _, VoidCallback openContainer) =>
          AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
              color: Color(colors[random]),
              image: const DecorationImage(
                image: AssetImage('assets/pattern.png'),
                repeat: ImageRepeat.repeat,
              )),
          child: content,
        ),
      ),
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ArticleContentPage(data: data);
      },
    );
    // return ZoomOutPress(
    //     child: AspectRatio(
    //       aspectRatio: aspectRatio,
    //       child: ClipRRect(
    //         borderRadius: const BorderRadius.all(
    //           Radius.circular(20),
    //         ),
    //         child: Container(
    //           decoration: BoxDecoration(
    //               color: Color(colors[random]),
    //               image: const DecorationImage(
    //                 image: AssetImage('assets/pattern.png'),
    //                 repeat: ImageRepeat.repeat,
    //               )),
    //           child: content,
    //         ),
    //       ),
    //     ),
    //     onPress: () {
    //       Get.to(
    //         ArticleContentPage(data: data),
    //         duration: const Duration(
    //           milliseconds: 600,
    //         ),
    //         transition: Transition.cupertino,
    //         curve: Curves.linear,
    //       );
    //     });
  }
}
