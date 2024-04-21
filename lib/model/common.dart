import 'dart:convert';

class Pagination {
  int page = 0;
  int size = 10;
  bool isMore = true;
  bool loading = false;
}

class BaseRes<T> {
  late String msg;
  late int code;
  late T data;

  BaseRes.fromJson(Map<String, dynamic>? obj) {
    if (obj?['data'] != null && obj?['data'] != 'null') {
      data = obj?['data'] as T;
    }
    msg = obj?['msg'];
    code = obj?['code'];
  }
}

class ListRes<T> {
  List<T> list = [];
  int page = 1;
  int size = 10;
  int total = 0;

  ListRes({required this.list, this.page = 1, this.size = 10, this.total = 0});
}
