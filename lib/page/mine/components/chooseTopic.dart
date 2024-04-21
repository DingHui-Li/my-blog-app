import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blog_app/controller/homeController.dart';
import 'package:my_blog_app/controller/publishController.dart';
import 'package:my_blog_app/controller/topicController.dart';

class ChooseTopic extends StatefulWidget {
  const ChooseTopic({Key? key}) : super(key: key);

  @override
  _ChooseTopicState createState() => _ChooseTopicState();
}

class _ChooseTopicState extends State<ChooseTopic> {
  TopicController topicController = Get.find<TopicController>();
  PublishController publishController = Get.find<PublishController>();

  @override
  void initState() {
    // TODO: implement initState
    if (topicController.list.value.isEmpty) {
      topicController.getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('选择话题'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          child: Obx(
            () => Wrap(
              spacing: 15,
              runSpacing: 5,
              children: topicController.list.value.map<Widget>((item) {
                bool isSelected = publishController.newForm.value.topics
                    .where((e) => e.id == item.id)
                    .isNotEmpty;
                return CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.blueAccent : Colors.transparent,
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.black.withOpacity(0.5),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      publishController.newForm.update((val) {
                        if (isSelected) {
                          val!.topics.remove(item);
                        } else {
                          val!.topics.add(item);
                        }
                      });
                    });
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
