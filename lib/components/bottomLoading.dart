import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BottomLoading extends StatelessWidget {
  bool loading;
  bool isMore;
  Function loadMore;
  BottomLoading(
      {Key? key,
      required this.loading,
      required this.isMore,
      required this.loadMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key('bottom loading'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0) {
            loadMore();
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              loading
                  ? const LinearProgressIndicator(minHeight: 4)
                  : const SizedBox(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  loading
                      ? '加载中'
                      : isMore
                          ? ''
                          : '没有更多了',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xff999999)),
                ),
              )
            ],
          ),
        ));
  }
}
