import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/components/bottomBar.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/page/home/index.dart';
import 'package:my_blog_app/page/mine/index.dart';
import 'package:my_blog_app/page/topic/index.dart';

void main() async {
  await Get.putAsync(() => SysController().init());
  runApp(const MyBlog());
}

class MyBlog extends StatefulWidget {
  const MyBlog({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MyBlog> {
  List tabs = [() => HomePage(), () => TopicPage(), () => MinePage()];
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        home: Scaffold(
            // extendBody: true,
            body: tabs[tabIndex](),
            bottomNavigationBar: BottomBar(
              onTap: (int index) {
                setState(() {
                  tabIndex = index;
                });
              },
            )),
      ),
    );
  }
}
