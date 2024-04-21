import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_blog_app/api/articleApi.dart';
import 'package:my_blog_app/api/sysApi.dart';
import 'package:my_blog_app/model/article.dart';

class PublishController extends GetxController {
  final Rx<Article> newForm = Article().obs;
  Rx<List<ChoosedImg>> choosedImg = Rx([]);
  int maxImgLen = 9;

  clear() {
    newForm.value = Article();
    choosedImg.value = [];
  }

  Future handlePublish() async {
    List<Future> futures = [];
    for (int index = 0; index < choosedImg.value.length; index++) {
      var item = choosedImg.value[index];
      if (item.url != '') {
        continue;
      }
      futures.add(uploadImg(index));
    }
    await Future.forEach(futures, (element) => null);
    for (var element in choosedImg.value) {
      if (!element.uploadSuccess) {
        return;
      }
    }
    Map<String, dynamic> payload = newForm.value.toJson();
    payload['htmlContent'] = payload['textContent'];
    payload['topics'] = newForm.value.topics.map((e) => e.id).toList();
    payload['imgs'] = choosedImg.value.map((e) => e.url).toList();
    payload.remove('id');
    payload.remove('createTime');
    payload.remove('updateTime');
    return ArticleApi.publish(payload);
  }

  Future uploadImg(int index) {
    var item = choosedImg.value[index];
    choosedImg.update((val) {
      val![index].uploading = true;
    });
    return SysApi.uploadImg(item.file).then(
      (url) {
        choosedImg.update((val) {
          val![index].uploading = false;
          val![index].uploadSuccess = true;
          val[index].url = url;
        });
      },
      // ignore: argument_type_not_assignable_to_error_handler
    ).catchError((err) {
      choosedImg.update((val) {
        val![index].uploading = false;
        val[index].uploadSuccess = false;
      });
    });
  }
}

class ChoosedImg {
  XFile file;
  String url;
  bool uploading;
  bool uploadSuccess;

  ChoosedImg({
    required this.file,
    this.url = "",
    this.uploading = false,
    this.uploadSuccess = true,
  });
}
