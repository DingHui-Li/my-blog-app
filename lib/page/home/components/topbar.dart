import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/controller/homeController.dart';

// ignore: must_be_immutable
class Topbar extends StatelessWidget {
  HomeController homeController = Get.find<HomeController>();

  Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => SliverAppBar(
        title: Text(
          'vvcx',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        snap: false,
        floating: false,
        pinned: true,
        elevation: 1,
        backgroundColor: Colors.white,
        expandedHeight: screenWidth * (3 / 4),
        flexibleSpace: FlexibleSpaceBar(
            background: Stack(
          children: [
            Image.network(
              "http://blog465467.oss-cn-guangzhou.aliyuncs.com/setting/eea4be7072889af8fbfb2fd8e8dc1a1b54389720940c002fd2340b1aace9b7b7.jpeg",
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        )),
        bottom: TabBar(
          controller: homeController.tabController,
          tabs: homeController.tabList
              .map(
                (TabData item) => Tab(
                  child: Text(
                    item.name,
                    style: TextStyle(
                        color: homeController.headerIsExpanded.value
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
