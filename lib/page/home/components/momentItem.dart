import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/components/zoomOutPress.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/model/sys.dart';
import 'package:my_blog_app/page/home/components/topic.dart';
import 'package:my_blog_app/page/photoView.dart';

class MomentItem extends StatelessWidget {
  final SysController _sysController = Get.find<SysController>();
  final HomeController _homeController = Get.find<HomeController>();
  late ProfileConf profileConf;
  Article data;
  MomentItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    profileConf = _sysController.settingConf.profile;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Image.network(
            MyBlog.getThumb(profileConf.avatar, size: 50),
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            gaplessPlayback: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileConf.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff3f51b5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Moment(data.createTimeObj).format('LLLL'),
                style: const TextStyle(fontSize: 12, color: Color(0xff999999)),
              ),
              const SizedBox(height: 5),
              Text(
                data.textContent,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: data.topics
                    .map<Widget>((Topic item) => ComTopic(data: item))
                    .toList(),
              ),
              comPhotos(data.imgs),
              comInfo(context)
            ],
          ),
        )
      ],
    );
  }

  Widget comInfo(BuildContext context) {
    bool hideInfo = data.location.name == "" && data.weather['text'] == null;
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: hideInfo
                ? const SizedBox()
                : Wrap(
                    children: [
                      data.location.name != ""
                          ? InkWell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xff666666),
                                    size: 16,
                                  ),
                                  Text(
                                    data.location.name,
                                    style: const TextStyle(
                                      color: Color(0xff555555),
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                print(data.location);
                              },
                            )
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      data.weather['text'] != null
                          ? Text.rich(
                              TextSpan(
                                text: data.weather['text'] +
                                    data.weather['temp'] +
                                    '℃',
                                style: const TextStyle(
                                  color: Color(0xff555555),
                                  fontSize: 14,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('open page');
                                  },
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
          ),
          actions(context),
        ],
      ),
    );
  }

  Widget comPhotos(List<String> list) {
    if (list.length == 0) {
      return const SizedBox();
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: list.length < 3 ? 2 : 3,
      shrinkWrap: true,
      childAspectRatio: 1,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 5),
      children: list.asMap().entries.map<Widget>((entry) {
        int index = entry.key;
        String item = entry.value;
        return ZoomOutPress(
            toScale: 0.94,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                color: const Color(0xffeeeeee),
                child: Hero(
                    tag: item,
                    child: CachedNetworkImage(
                      imageUrl: MyBlog.getThumb(item, size: 200),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // gaplessPlayback: true,
                    )),
              ),
            ),
            onPress: () {
              Get.to(() => PhotoView(index: index, imgs: list),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            });
      }).toList(),
    );
  }

  Widget actions(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
          child: const Text('删除'),
          onPressed: () {
            Get.back();
            showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('确定要删除吗？'),
                    content: const Text(
                      '删除后无法恢复，是否继续',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Get.back();
                            _homeController.remove(PageDataType.Moment, data);
                          },
                          child: const Text(
                            '确定',
                            style: TextStyle(color: Colors.red),
                          )),
                      CupertinoDialogAction(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            '取消',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  );
                });
          },
        )
      ],
      builder: (context, animation) {
        return const IconButton(
          icon: Icon(
            Icons.more,
            size: 15,
            color: Colors.black87,
          ),
          onPressed: null,
        );
      },
    );
  }
}
