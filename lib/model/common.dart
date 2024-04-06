import 'dart:convert';

class Pagination {
  int page = 1;
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
