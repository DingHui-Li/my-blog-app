import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_blog_app/api/sysApi.dart';
import 'package:my_blog_app/model/sys.dart';

class SysController extends GetxController {
  // ignore: non_constant_identifier_names
  late final GetStorage box;
  // ignore: non_constant_identifier_names
  late String API_HOST;

  SettingConf settingConf = SettingConf();

  Future<SysController> init() async {
    await GetStorage.init();
    box = GetStorage();
    API_HOST = "http://124.71.61.179" ??
        box.read('API_HOST') ??
        "http://124.71.61.179";
    box.write('API_HOST', API_HOST);

    await getSettingConf();

    return this;
  }

  getSettingConf() {
    return SysApi.getConf().then((res) {
      settingConf = res;
    });
  }

  login(String code) {
    return SysApi.login(code).then((token) {
      box.write('token', token);
      return token;
    });
  }

  logout() {
    box.write('token', '');
  }

  bool get isLogin {
    String token = box.read('token') ?? '';
    return token != '';
  }
}
