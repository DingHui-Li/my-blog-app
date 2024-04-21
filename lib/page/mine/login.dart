import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/controller/sysController.dart';
import 'package:my_blog_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  String input = '';
  bool loging = false;
  SysController sysController = Get.find<SysController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Widget panel = Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(top: 30, left: 45, right: 45),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            '登录',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '输入动态验证码以登录',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
              ),
              child: TextField(
                readOnly: loging,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(border: InputBorder.none),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    login(value);
                  }
                  setState(() {
                    input = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onPressed: loging
                  ? null
                  : () {
                      login(input);
                    },
              child: loging
                  ? const CupertinoActivityIndicator()
                  : const Text('验证'),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: CupertinoButton(
              child: const Text(
                '了解TOTP验证',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                launchUrl(Uri.parse(
                    "https://baike.baidu.com/item/Google%20Authenticator/58350750?fr=ge_ala"));
              },
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: CachedNetworkImage(
              imageUrl: MyBlog.getThumb(sysController.settingConf.website.cover,
                  size: 1000),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: width * (3 / 4) + 30),
              child: panel,
            ),
          )
        ],
      ),
    );
  }

  void login(String code) async {
    if (loging) return;
    setState(() {
      loging = true;
    });
    try {
      await sysController.login(code);
      Get.back();
    } finally {
      setState(() {
        loging = false;
      });
    }
  }
}
