import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/util/http.dart';

class TopicApi {
  static HttpHelper? http = HttpHelper.instance;

  static Future<List<Topic>> getList() {
    return http!.get('/api/topic/st').then((res) {
      List<Topic> list =
          res.data?.map<Topic>((item) => Topic.fromJson(item)).toList();
      return list;
    });
  }
}
