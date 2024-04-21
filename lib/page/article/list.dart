import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/components/bottomLoading.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/article/components/article.dart';

// ignore: must_be_immutable
class ArticleList extends StatelessWidget {
  ArticleList({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        middle: const Text(
          '文章',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: 80,
        onRefresh: () {
          return homeController.getList(type: PageDataType.Article);
        },
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 95, 10, 15),
            itemCount: homeController.articleData.value.list.length + 1,
            itemBuilder: (context, index) {
              if (index < homeController.articleData.value.list.length) {
                Article article = homeController.articleData.value.list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ArticleCard(
                    data: article,
                    aspectRatio: 16 / 9,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: BottomLoading(
                    loading:
                        homeController.articleData.value.pagination.loading,
                    isMore: homeController.articleData.value.pagination.isMore,
                    loadMore: () =>
                        homeController.loadMore(type: PageDataType.Article),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
