import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_blog_app/components/bottomLoading.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/page/home/components/artticleItem.dart';
import 'package:my_blog_app/page/home/components/momentItem.dart';
import 'package:my_blog_app/page/home/components/topbar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final HomeController homeController = Get.find<HomeController>();
  SysController sysController = Get.find<SysController>();

  @override
  Widget build(BuildContext context) {
    Widget body = NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          [Topbar()],
      body: Container(
        color: Colors.white,
        child: Obx(
          () => RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () {
              return homeController.getList(type: PageDataType.Moment);
            },
            child: ListView.builder(
              addAutomaticKeepAlives: false,
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemCount: homeController.momentData.value.list.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < homeController.momentData.value.list.length) {
                  var item = homeController.momentData.value.list[index];
                  return comItem(
                    item.type == 'article'
                        ? ArtticleItem(data: item)
                        : MomentItem(data: item),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: BottomLoading(
                      loading:
                          homeController.momentData.value.pagination.loading,
                      isMore: homeController.momentData.value.pagination.isMore,
                      loadMore: () =>
                          homeController.loadMore(type: PageDataType.Moment),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
    return body;
  }

  Widget comItem(Widget widget) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
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

  @override
  bool get wantKeepAlive => true;
}
