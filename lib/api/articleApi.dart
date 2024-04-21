import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/model/common.dart';
import 'package:my_blog_app/util/http.dart';

class ArticleApi {
  static HttpHelper? http = HttpHelper.instance;

  static Future<ListRes<Article>> getList(Map<String, dynamic> params) {
    return http!.get("/api/article", params: params).then((res) {
      List<Article> list = res.data['list']
          ?.map<Article>((item) => Article.fromJson(item))
          .toList();
      return ListRes(
          list: list,
          page: res.data['page'],
          size: res.data['size'],
          total: res.data['total']);
    });
  }

  static Future<Article> getDetail(String id) {
    return http!.get('/api/article/$id').then((res) {
      return Article.fromJson(res.data);
    });
  }

  static Future publish(dynamic data) {
    return http!.post('/api/admin/article', params: data).then((res) {
      return res;
    });
  }

  static Future remove(String id) {
    return http!.delete('/api/admin/article/${id}').then((res) {
      return res;
    });
  }
}
