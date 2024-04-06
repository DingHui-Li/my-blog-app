import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_blog_app/model/article.dart';
import 'package:my_blog_app/page/home/components/topic.dart';

class MomentItem extends StatelessWidget {
  Article data;
  MomentItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Image.network(
            "http://blog465467.oss-cn-guangzhou.aliyuncs.com/setting/5b209971d196ffdb5183160e911e7552f87ff6a86054427b41975a873285956b.jpeg?x-oss-process=image/resize,m_fill,w_100",
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'userName',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff3f51b5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "2024年4月5日123：234：234",
                style: TextStyle(fontSize: 10, color: Color(0xff999999)),
              ),
              SizedBox(height: 5),
              Text(
                data.textContent,
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 10),
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: data.topics
                    .map<Widget>((Topic item) => ComTopic(data: item))
                    .toList(),
              ),
              comPhotos(data.imgs),
              comInfo()
            ],
          ),
        )
      ],
    );
  }

  Widget comInfo() {
    if (data.location.name == "" && data.weather['text'] == null) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        children: [
          data.location.name != ""
              ? InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, 1),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Color(0xff666666),
                          size: 12,
                        ),
                      ),
                      Text(
                        data.location.name,
                        style:
                            TextStyle(color: Color(0xff555555), fontSize: 10),
                      )
                    ],
                  ),
                  onTap: () {
                    print(data.location);
                  },
                )
              : SizedBox(),
          SizedBox(width: 10),
          data.weather['text'] != null
              ? Text.rich(
                  TextSpan(
                      text: data.weather['text'] + data.weather['temp'] + '℃',
                      style: TextStyle(color: Color(0xff555555), fontSize: 10),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('open page');
                        }),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget comPhotos(List<String> list) {
    if (list.length == 0) {
      return const SizedBox();
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 5),
      children: list.map<Widget>((String item) {
        return Stack(
          children: [
            Image.network(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print('img open');
                  },
                ),
              ),
            )
          ],
        );
      }).toList(),
    );
  }
}
