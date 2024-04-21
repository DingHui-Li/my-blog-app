import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/components/bottomLoading.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/page/home/components/photoItem.dart';

// ignore: must_be_immutable
class PhotoPage extends StatefulWidget {
  PhotoPage({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<PhotoPage> with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  bool showTopbar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.offset >= 76) {
          setState(() {
            showTopbar = true;
          });
        } else {
          setState(() {
            showTopbar = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      edgeOffset: 100,
      onRefresh: () {
        return widget.homeController.getList(type: PageDataType.Photo);
      },
      child: Obx(
        () {
          var data = widget.homeController.photoData;
          var mapList = data.value.mapListByDate;
          List dateList = mapList.keys.toList();
          return (data.value.pagination.loading && dateList.isEmpty)
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  addAutomaticKeepAlives: false,
                  padding: const EdgeInsets.fromLTRB(15, 80, 15, 15),
                  itemCount: dateList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < dateList.length) {
                      var item = mapList[dateList[index]];
                      return PhotoItem(
                        list: item!,
                        isFirst: index == 0,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: BottomLoading(
                          loading: data.value.pagination.loading,
                          isMore: data.value.pagination.isMore,
                          loadMore: () => widget.homeController
                              .loadMore(type: PageDataType.Photo),
                        ),
                      );
                    }
                  },
                );
        },
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            width: showTopbar ? 1 : 0,
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        middle: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: showTopbar ? 1 : 0,
          child: const Text(
            '相册',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: body,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
