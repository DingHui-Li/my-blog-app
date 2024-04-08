import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/model/common.dart';
import 'package:my_blog_app/util/http.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxBool headerIsExpanded = RxBool(false);
  late TabController tabController;
  HttpHelper? http = HttpHelper.instance;

  final Rx<PageData> momentData = PageData().obs;
  final Rx<PageData> articleData = PageData().obs;
  final Rx<PageData> photoData = PageData().obs;
  final Rx<PageData> movieData = PageData().obs;

  List<TabData> tabList = [];
  RxInt activeTab = RxInt(0);

  HomeController() {
    tabList = [
      TabData(name: "动态", type: "moment", data: momentData),
      TabData(name: "文章", type: "article", data: articleData),
      TabData(name: "相册", type: "photo", data: photoData),
      TabData(name: "电影", type: "movie", data: movieData),
    ];
    getList();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        headerIsExpanded.value = scrollController.offset >= 190;
      }
    });
  }

  void onTabChange() {
    if (!tabController.indexIsChanging) {
      activeTab.value = tabController.index;
      if (tabList[activeTab.value].data.value.list.isEmpty) {
        getList();
      }
    }
  }

  void loadMore() {
    Pagination pagination = tabList[activeTab.value].data.value.pagination;
    if (pagination.isMore && !pagination.loading) {
      getList(page: pagination.page + 1);
    }
  }

  Future<void> getList({int page = 1}) async {
    TabData tab = tabList[activeTab.value];
    Pagination pagination = tab.data.value.pagination;
    if (pagination.loading) {
      return Future.value();
    }
    tab.data.update((val) {
      val?.pagination.loading = true;
    });
    http?.get("/api/article", params: {
      "type": tab.type,
      "page": page,
      "size": pagination.size
    }).then((res) {
      List<Article> list = res.data['list']
          ?.map<Article>((item) => Article.fromJson(item))
          .toList();
      tab.data.update((val) {
        if (page == 1) {
          val?.list = list;
        } else {
          val?.list.addAll(list);
        }
        val?.pagination.page = page;
        val?.pagination.isMore = page * pagination.size < res.data['total'];
        val?.pagination.loading = false;
      });
    }).catchError((error) {
      print(error);
      tab.data.update((val) {
        val?.pagination.isMore = false;
        val?.pagination.loading = false;
      });
    });
  }
}

class PageData {
  List<Article> list = [];
  Pagination pagination = Pagination();
}

class TabData {
  String name = '';
  String type = '';
  late Rx<PageData> data;

  TabData({required this.name, required this.type, required this.data});
}
