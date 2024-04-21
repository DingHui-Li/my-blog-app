import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/main.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  Function onTap;
  SysController sysController = Get.find<SysController>();

  BottomBar({Key? key, required this.onTap}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: NavigationBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white.withOpacity(0.9),
          onDestinationSelected: (int index) {
            setState(() => currentPageIndex = index);
            widget.onTap(index);
          },
          selectedIndex: currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.mood_outlined),
              selectedIcon: Icon(Icons.mood),
              label: "",
            ),
            const NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article),
              label: "",
            ),
            const NavigationDestination(
              icon: Icon(Icons.photo_camera_back_outlined),
              selectedIcon: Icon(Icons.photo_camera_back_rounded),
              label: "",
            ),
            NavigationDestination(
              // icon: Icon(Icons.person_outline),
              icon: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(
                      widget.sysController.settingConf.profile.avatar,
                      size: 100),
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              selectedIcon: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: MyBlog.getThumb(
                      widget.sysController.settingConf.profile.avatar,
                      size: 100),
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              label: "",
            )
          ],
        ),
      ),
    );
  }
}
