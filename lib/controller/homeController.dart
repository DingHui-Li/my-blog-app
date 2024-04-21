import 'dart:async';

import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/api/articleApi.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/model/common.dart';
import 'package:my_blog_app/util/http.dart';

class HomeController extends GetxController {
  // ScrollController scrollController = ScrollController();
  // RxBool headerIsExpanded = RxBool(false);
  // late TabController tabController;
  HttpHelper? http = HttpHelper.instance;

  final Rx<PageData> momentData = PageData().obs;
  final Rx<PageData> articleData = PageData().obs;
  final Rx<PageData> photoData = PageData().obs;
  final Rx<PageData> movieData = PageData().obs;

  // List<TabData> tabList = [];
  // RxInt activeTab = RxInt(0);
  late Map<PageDataType, Rx<PageData>> pageMap;

  HomeController() {
    pageMap = {
      PageDataType.Moment: momentData,
      PageDataType.Article: articleData,
      PageDataType.Photo: photoData,
      PageDataType.Movie: movieData,
    };
    // tabList = [
    //   TabData(name: "动态", type: "moment", data: momentData),
    //   TabData(name: "文章", type: "article", data: articleData),
    //   TabData(name: "相册", type: "photo", data: photoData),
    //   TabData(name: "电影", type: "movie", data: movieData),
    // ];
    // scrollController.addListener(() {
    //   double screenWidth =
    //       PlatformDispatcher.instance.views.first.display.size.width;
    //   if (scrollController.hasClients) {
    //     headerIsExpanded.value =
    //         scrollController.offset >= screenWidth * (3 / 4) - 60;
    //   }
    // });
  }

  // void onTabChange() {
  //   if (!tabController.indexIsChanging) {
  //     activeTab.value = tabController.index;
  //     if (tabList[activeTab.value].data.value.list.isEmpty) {
  //       getList();
  //     }
  //   }
  // }

  void loadMore({required PageDataType type}) {
    Pagination pagination = pageMap[type]!.value.pagination;
    if (pagination.isMore && !pagination.loading) {
      getList(page: pagination.page + 1, type: type);
    }
  }

  Future<void> getList({int page = 1, required PageDataType type}) async {
    Rx<PageData> data = pageMap[type]!;
    Pagination pagination = data.value.pagination;
    if (pagination.loading) {
      return Future.value();
    }
    data.update((val) {
      val?.pagination.loading = true;
    });
    return ArticleApi.getList({
      "type": type.name.toLowerCase(),
      "page": page,
      "size": pagination.size
    }).then((res) {
      data.update((val) {
        if (page == 1) {
          val?.list = res.list;
          val?.mapListByDate = {};
        } else {
          val?.list.addAll(res.list);
        }
        for (var item in res.list) {
          String date = Moment(item.createTimeObj).format('YYYY-MM-DD');
          val?.mapListByDate[date] = [...?val.mapListByDate[date], item];
        }
        val?.pagination.page = page;
        val?.pagination.isMore = page * pagination.size < res.total;
        val?.pagination.loading = false;
      });
    }).catchError((error) {
      print(error);
      data.update((val) {
        val?.pagination.loading = false;
      });
    });
  }

  remove(PageDataType type, Article data) {
    ArticleApi.remove(data.id).then((res) {
      pageMap[type]!.update((val) {
        val!.list.remove(data);
      });
    });
  }
}

class PageData {
  List<Article> list = [];
  Map<String, List<Article>> mapListByDate = {};
  Pagination pagination = Pagination();
}

// class TabData {
//   String name = '';
//   String type = '';
//   late Rx<PageData> data;

//   TabData({required this.name, required this.type, required this.data});
// }

// ignore: constant_identifier_names
enum PageDataType { Moment, Article, Photo, Movie }
