import 'package:get/get.dart';
import 'package:my_blog_app/api/topicApi.dart';
import 'package:my_blog_app/model/article.dart';

class TopicController extends GetxController {
  Rx<List<Topic>> list = Rx([]);

  getList() {
    return TopicApi.getList().then((res) {
      list.value = res;
    });
  }
}
