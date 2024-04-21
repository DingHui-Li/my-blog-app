import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/publishController.dart';
import 'package:my_blog_app/model/article.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  PublishController publishController = Get.find<PublishController>();
  late InAppWebViewController controller;
  bool loading = true;
  List poiList = [];
  String input = '';
  Position? position;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    _determinePosition().then((res) {
      setState(() {
        position = res;
      });
      // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((err) {
      setState(() {
        position = Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('选择位置'),
      ),
      body: Stack(
        children: [
          webview(),
          ListView.builder(
            padding: const EdgeInsets.only(top: 80),
            itemCount: poiList.length,
            itemBuilder: (context, index) {
              var item = poiList[index];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    )),
                child: ListTile(
                  title: Text(item['name'] ?? ""),
                  subtitle: Text(
                    item['address'] ?? "街道",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    item['location'] = {
                      "lat": item['location'][1],
                      "lng": item['location'][0]
                    };
                    publishController.newForm.update((val) {
                      val!.location = Location.fromJson(item);
                      Get.back();
                    });
                  },
                ),
              );
            },
          ),
          loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
            child: searchBox(),
          ),
        ],
      ),
    );
  }

  Widget webview() {
    return SizedBox(
      height: 0,
      child: position != null
          ? InAppWebView(
              initialSettings: InAppWebViewSettings(
                underPageBackgroundColor: Colors.white,
              ),
              onWebViewCreated: (controller) {
                controller.addJavaScriptHandler(
                    handlerName: "poiList",
                    callback: (res) async {
                      List list = res[0];
                      List<dynamic> uniqueList = [];
                      for (dynamic item in list) {
                        if (uniqueList
                            .where((el) => el['name'] == item['name'])
                            .isEmpty) {
                          uniqueList.add(item);
                        }
                      }
                      setState(() {
                        poiList = uniqueList;
                        loading = false;
                      });
                    });
                controller.addJavaScriptHandler(
                    handlerName: "searchAddressCallback",
                    callback: (res) async {
                      setState(() {
                        poiList = res[0];
                        loading = false;
                      });
                    });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  this.controller = controller;
                });
              },
              initialUrlRequest: URLRequest(
                url: WebUri(box.read('API_HOST') +
                    '/webview/chooseLocationMap?lat=${position!.latitude}&lng=${position!.longitude}'),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget searchBox() {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "搜索位置"),
              onChanged: (v) {
                setState(() {
                  input = v;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              searchAddress(input);
            },
            icon: const Icon(
              CupertinoIcons.search_circle_fill,
              size: 40,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }

  void searchAddress(String text) {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    controller.evaluateJavascript(source: "searchAddress('$text')");
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Location services are disabled..................................................');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied.....................................................');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions...............................................');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30));
  }
}
