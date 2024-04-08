import 'package:flutter/material.dart';
import 'package:my_blog_app/components/bottomLoading.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/page/home/components/artticleItem.dart';
import 'package:my_blog_app/page/home/components/momentItem.dart';
import 'package:my_blog_app/page/home/components/topbar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<HomePage> with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.tabController =
        TabController(length: homeController.tabList.length, vsync: this)
          ..addListener(homeController.onTabChange);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: homeController.scrollController,
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          [Topbar()],
      body: TabBarView(
          controller: homeController.tabController,
          children: homeController.tabList.map((TabData tab) {
            return Obx(
              () => RefreshIndicator(
                  child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    padding: const EdgeInsets.all(0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: tab.data.value.list.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < tab.data.value.list.length) {
                        var item = tab.data.value.list[index];
                        return comItem(
                          item.type == 'article'
                              ? ArtticleItem(data: item)
                              : MomentItem(data: item),
                        );
                      } else {
                        return BottomLoading(
                          loading: tab.data.value.pagination.loading,
                          isMore: tab.data.value.pagination.isMore,
                          loadMore: homeController.loadMore,
                        );
                      }
                    },
                  ),
                  onRefresh: () {
                    return homeController.getList();
                  }),
            );
          }).toList()),
    );
  }

  Widget comItem(Widget widget) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffeeeeee),
            width: 1,
          ),
        ),
      ),
      child: widget,
    );
  }
}
