import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/topicController.dart';
import 'package:my_blog_app/page/article/components/article.dart';
import 'package:my_blog_app/page/article/components/topic.dart';
import 'package:my_blog_app/page/article/list.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {
  HomeController homeController = Get.find<HomeController>();
  TopicController topicController = Get.find<TopicController>();

  @override
  void initState() {
    super.initState();
    homeController.getList(type: PageDataType.Article);
    topicController.getList();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = RefreshIndicator(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 80),
        children: [
          header('最近文章', () {
            Get.to(
              ArticleList(),
              duration: const Duration(
                milliseconds: 400,
              ),
              transition: Transition.cupertino,
              curve: Curves.easeIn,
            );
          }),
          SizedBox(
            height: MediaQuery.of(context).size.width * (3 / 4),
            child: Obx(
              () => ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                scrollDirection: Axis.horizontal,
                children: homeController.articleData.value.list
                    .map<Widget>(
                      (item) => Padding(
                          padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                          child: ArticleCard(data: item)),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 15),
          header('主题列表', () {}),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Obx(
              () => Wrap(
                spacing: 15,
                runSpacing: 5,
                children: topicController.list.value.map<Widget>((item) {
                  return TopicBtn(data: item);
                }).toList(),
              ),
            ),
          )
        ],
      ),
      onRefresh: () {
        return Future.any([
          homeController.getList(type: PageDataType.Article),
          topicController.getList(),
        ]);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }

  Widget header(String text, Function onPressed) {
    return CupertinoButton(
      onPressed: () {
        onPressed();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Icon(
            Icons.chevron_right_outlined,
            size: 25,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
