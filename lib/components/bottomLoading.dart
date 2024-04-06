import 'package:flutter/material.dart';

class BottomLoading extends StatelessWidget {
  bool loading;
  bool isMore;
  BottomLoading({Key? key, required this.loading, required this.isMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loading
              ? const LinearProgressIndicator(minHeight: 2)
              : const SizedBox(),
          const SizedBox(height: 10),
          Center(
            child: Text(
              loading
                  ? '加载中'
                  : isMore
                      ? '上拉加载'
                      : '没有更多了',
              style: const TextStyle(fontSize: 12, color: Color(0xff999999)),
            ),
          )
        ],
      ),
    );
  }
}
