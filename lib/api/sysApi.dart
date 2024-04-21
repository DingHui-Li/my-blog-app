import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_blog_app/model/sys.dart';
import 'package:my_blog_app/util/http.dart';

class SysApi {
  static HttpHelper? http = HttpHelper.instance;

  static Future<SettingConf> getConf() {
    return http!.get('/api/sys/setting').then((res) {
      return SettingConf.fromJson(res.data);
    });
  }

  static Future<String> login(String code) {
    return http!.post('/api/login', params: {'code': code}).then((res) {
      return res.data['token'] ?? "";
    });
  }

  static Future uploadImg(XFile file, {String dir = 'photo'}) async {
    final formData = FormData.fromMap({
      'dir': dir,
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
        contentType: MediaType('image', file.name.split('.')[1]),
      ),
    });
    return http!.post('/api/admin/file/upload', formData: formData).then((res) {
      return res.data;
    });
  }
}
