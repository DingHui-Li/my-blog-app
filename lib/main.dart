import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/components/bottomBar.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/controller/topicController.dart';
import 'package:my_blog_app/page/article/index.dart';
import 'package:my_blog_app/page/home/index.dart';
import 'package:my_blog_app/page/home/photo.dart';
import 'package:my_blog_app/page/mine/index.dart';
import 'package:my_blog_app/page/topic/index.dart';

void main() async {
  Moment.setGlobalLocalization(MomentLocalizations.zhCn());
  await Get.putAsync(() => SysController().init());
  Get.put(HomeController());
  Get.put(TopicController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyBlog());
}

class MyBlog extends StatefulWidget {
  const MyBlog({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
  static String getThumb(String url, {int size = 100}) {
    return '$url?x-oss-process=image/resize,m_mfit,w_$size';
  }
}

class _MainState extends State<MyBlog> {
  // List tabs = [() => HomePage(), () => TopicPage(), () => MinePage()];
  // int tabIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        home: Scaffold(
            extendBody: true,
            body: PageView(
              controller: pageController,
              children: [HomePage(), ArticlePage(), PhotoPage(), MinePage()],
              physics: const NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: BottomBar(
              onTap: (int index) {
                pageController.jumpToPage(index);
              },
            )),
      ),
    );
  }
}
