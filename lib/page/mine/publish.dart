import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_blog_app/controller/publishController.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/mine/components/chooseLocation.dart';
import 'package:my_blog_app/page/mine/components/chooseTopic.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  PublishController publishController = Get.put(PublishController());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = publishController.newForm.value.textContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        trailing: CupertinoButton(
          minSize: 30,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          color: Colors.green,
          onPressed: () {
            publishController.handlePublish().then((res) {
              showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: const Text('发表成功'),
                        actions: [
                          CupertinoButton(
                              child: const Text(
                                '确定',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                publishController.clear();
                                textEditingController.text = '';
                                Get.back();
                                Get.back();
                              })
                        ],
                      ));
            });
          },
          child: const Text(
            '发表',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Obx(
          () => Column(
            children: [
              TextFormField(
                controller: textEditingController,
                minLines: 4,
                maxLines: 100,
                decoration: const InputDecoration(
                  hintText: "这一刻的想法...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
                onChanged: (value) {
                  publishController.newForm.update((val) {
                    val!.textContent = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                children: [
                  ...publishController.choosedImg.value
                      .asMap()
                      .entries
                      .map<Widget>((e) {
                    return imgItem(e.value, e.key);
                  }).toList(),
                  publishController.choosedImg.value.length <
                          publishController.maxImgLen
                      ? uploadImg()
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 20),
              // Divider(color: Colors.grey.withOpacity(0.1)),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(CupertinoIcons.location, size: 18),
                title: Text(publishController.newForm.value.location.name == ""
                    ? "选择位置"
                    : publishController.newForm.value.location.name),
                trailing: const Icon(CupertinoIcons.right_chevron, size: 15),
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (_) => const ChooseLocation(),
                  );
                },
              ),
              Divider(color: Colors.grey.withOpacity(0.1)),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(CupertinoIcons.number, size: 18),
                title: publishController.newForm.value.topics.isEmpty
                    ? const Text("选择话题")
                    : Wrap(
                        children: publishController.newForm.value.topics
                            .map<Widget>((e) => Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    '#${e.name}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      ),
                trailing: const Icon(CupertinoIcons.right_chevron, size: 15),
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (_) => const ChooseTopic(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImg() {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      color: const Color(0xfff5f5f5),
      child: const Center(
        child: Icon(
          CupertinoIcons.add,
          size: 40,
          color: Colors.grey,
        ),
      ),
      onPressed: () {
        final ImagePicker picker = ImagePicker();
        // ignore: avoid_single_cascade_in_expression_statements
        picker
          ..pickMultiImage(
                  limit: publishController.maxImgLen -
                      publishController.choosedImg.value.length)
              .then((list) {
            setState(() {
              publishController.choosedImg.update((val) {
                for (var item in list) {
                  val!.add(ChoosedImg(file: item));
                }
              });
            });
          });
      },
    );
  }

  Widget imgItem(ChoosedImg item, int index) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Stack(
        children: [
          Image.file(
            File(item.file.path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          item.uploading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CupertinoActivityIndicator(color: Colors.white),
                  ),
                )
              : const SizedBox(),
          !item.uploading && !item.uploadSuccess
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        publishController.uploadImg(index);
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
