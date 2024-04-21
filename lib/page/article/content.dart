import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_blog_app/api/articleApi.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/main.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/home/components/topic.dart';
import 'package:my_blog_app/page/photoView.dart';

class ArticleContentPage extends StatefulWidget {
  Article data;
  ArticleContentPage({Key? key, required this.data}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<ArticleContentPage> {
  bool loading = true;
  double webviewHeight = 200;
  HomeController homeController = Get.find<HomeController>();
  GetStorage box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ArticleApi.getDetail(widget.data.id).then((res) {
    //   setState(() {
    //     widget.data = res;
    //     loading = false;
    //   });
    // }).catchError(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget body = DismissiblePage(
      backgroundColor: Colors.white,
      direction: DismissiblePageDismissDirection.down,
      child: SingleChildScrollView(
        child: Column(
          children: [
            widget.data.cover != ''
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: MyBlog.getThumb(widget.data.cover, size: 1000),
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : const SizedBox(height: 50),
            header(),
            content()
          ],
        ),
      ),
      onDismissed: () {
        Get.back();
      },
    );
    return Scaffold(
      body: body,
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            widget.data.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '发布于${Moment(widget.data.createTimeObj).format('LLLL')}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          // Text(
          //   '${Moment(DateTime.fromMillisecondsSinceEpoch(widget.data.updateTime)).fromNow()}更新',
          //   style: const TextStyle(fontSize: 14, color: Colors.grey),
          // ),
          const SizedBox(height: 5),
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: widget.data.topics
                .map<Widget>((Topic item) => ComTopic(data: item))
                .toList(),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.black.withOpacity(0.08)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget content() {
    Widget webview = AnimatedOpacity(
      opacity: loading ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          underPageBackgroundColor: Colors.white,
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
              handlerName: "clientHeight",
              callback: (res) async {
                double height = res[0] / 10;
                height = height < 400 ? 400 : height;
                setState(() {
                  loading = false;
                  webviewHeight = height;
                });
              });
          controller.addJavaScriptHandler(
              handlerName: "previewImg",
              callback: (res) async {
                Get.to(
                    () => PhotoView(
                          index: 0,
                          imgs: res.map((e) => e.toString()).toList(),
                        ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              });
        },
        initialUrlRequest: URLRequest(
          url: WebUri(
              box.read('API_HOST') + '/webview/article?id=${widget.data.id}'),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: webviewHeight,
        child: Stack(
          children: [
            const Center(
              child: CupertinoActivityIndicator(),
            ),
            webview
          ],
        ),
      ),
    );
  }
}
