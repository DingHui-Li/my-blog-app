import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/main.dart';

// ignore: must_be_immutable
class PhotoView extends StatefulWidget {
  List<String> imgs;
  int index;
  String heroTag;
  late PageController pageController;
  // ignore: use_key_in_widget_constructors
  PhotoView({
    Key? key,
    required this.imgs,
    required this.index,
    this.heroTag = '',
  }) {
    pageController = PageController(initialPage: index);
  }

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // pageController.jumpToPage(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      children: widget.imgs.map((item) {
        return DismissiblePage(
            direction: DismissiblePageDismissDirection.vertical,
            child: Hero(
              tag: '${item}${widget.heroTag}',
              child: CachedNetworkImage(
                imageUrl: item,
                fit: BoxFit.fitWidth,
                fadeInDuration: const Duration(milliseconds: 0),
                fadeOutDuration: const Duration(milliseconds: 0),
                placeholder: (context, url) => CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(item, size: 200),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            onDismissed: () {
              Get.back();
            });
      }).toList(),
    );
  }
}
