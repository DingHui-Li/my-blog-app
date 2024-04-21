import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/page/mine/login.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  SysController sysController = Get.find<SysController>();

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            clipBehavior: Clip.hardEdge,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 5, color: Colors.white),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: MyBlog.getThumb(
                    sysController.settingConf.profile.avatar,
                    size: 500),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            sysController.settingConf.profile.name,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height - 100 - 100 - 30 - 30,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30),
                //   topRight: Radius.circular(30),
                // ),
              ),
              child: Column(
                children: [
                  item(
                      icon: const Icon(
                        CupertinoIcons.compass,
                        color: Colors.green,
                      ),
                      text: '发现',
                      onTap: () {}),
                  item(
                      icon: const Icon(
                        CupertinoIcons.settings,
                        color: Colors.blue,
                      ),
                      text: '设置',
                      onTap: () {}),
                  Divider(color: Colors.grey.withOpacity(0.1)),
                  item(
                      icon: const Icon(
                        CupertinoIcons.info,
                        color: Colors.redAccent,
                      ),
                      text: '关于',
                      onTap: () {}),
                  item(
                      icon: const Icon(
                        Icons.login,
                        color: Colors.indigoAccent,
                      ),
                      text: "登录",
                      onTap: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return LoginPage();
                            });
                        // Get.to(
                        //   LoginPage(),
                        //   transition: Transition.cupertino,
                        //   duration: const Duration(milliseconds: 500),
                        //   curve: Curves.easeIn,
                        // );
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xfffafafb),
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: CachedNetworkImage(
              imageUrl: MyBlog.getThumb(
                  sysController.settingConf.profile.avatar,
                  size: 500),
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget item({required Icon icon, required String text, onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: icon,
      title: Text(text),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        size: 15,
      ),
      onTap: onTap != null
          ? () {
              onTap();
            }
          : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
