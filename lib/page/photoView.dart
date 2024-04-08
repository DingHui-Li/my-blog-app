import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PhotoView extends StatefulWidget {
  List<String> imgs;
  int index;
  late PageController pageController;
  PhotoView({Key? key, required this.imgs, required this.index}) {
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
            direction: DismissiblePageDismissDirection.multi,
            child: Hero(
              tag: item,
              child: CachedNetworkImage(
                imageUrl: item,
                fit: BoxFit.contain,
              ),
            ),
            onDismissed: () {
              Get.back();
            });
      }).toList(),
    );
  }
}
