import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/sys.dart';
import 'package:my_blog_app/page/mine/publish.dart';

// ignore: must_be_immutable
class Topbar extends StatelessWidget {
  // HomeController homeController = Get.find<HomeController>();
  SysController sysController = Get.find<SysController>();

  Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SliverAppBar(
      title: Text(
        sysController.settingConf.website.name,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                useRootNavigator: false,
                context: context,
                barrierColor: Colors.white.withOpacity(0.5),
                builder: (_) => PublishPage(),
              );
              // Get.to(PublishPage(), transition: Transition.downToUp);
            },
            icon: const Icon(
              Icons.camera,
              size: 22,
            ))
      ],
      centerTitle: true,
      snap: false,
      floating: false,
      pinned: true,
      elevation: 1,
      backgroundColor: Colors.white.withOpacity(0.99),
      expandedHeight: screenWidth * (3 / 4),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 0.98,
                child: CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(
                      sysController.settingConf.website.cover,
                      size: 1000),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
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
            Align(
              alignment: Alignment.bottomRight,
              child: userInfo(sysController.settingConf.profile),
            )
          ],
        ),
      ),
      // bottom: TabBar(
      //   controller: homeController.tabController,
      //   tabs: homeController.tabList
      //       .map(
      //         (TabData item) => Tab(
      //           child: Text(
      //             item.name,
      //             style: TextStyle(
      //                 color: homeController.headerIsExpanded.value
      //                     ? Colors.black
      //                     : Colors.white),
      //           ),
      //         ),
      //       )
      //       .toList(),
      // ),
    );
  }

  Widget userInfo(ProfileConf profileConf) {
    const double height = 60;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * (2 / 5),
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  profileConf.name,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(profileConf.avatar, size: 100),
                  width: height,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }
}
