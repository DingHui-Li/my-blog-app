import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SysController extends GetxController {
  // ignore: non_constant_identifier_names
  late final GetStorage box;
  // ignore: non_constant_identifier_names
  late String API_HOST;

  Future<SysController> init() async {
    await GetStorage.init();
    box = GetStorage();
    API_HOST = "http://124.71.61.179" ??
        box.read('API_HOST') ??
        "http://124.71.61.179";
    box.write('API_HOST', API_HOST);

    return this;
  }
}
