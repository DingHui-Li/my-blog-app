import 'package:dio/dio.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GETX;
import 'package:get_storage/get_storage.dart';
import 'package:my_blog_app/model/common.dart';

class HttpHelper {
  static Dio? dio;
  static HttpHelper? http;
  static GetStorage _box = GetStorage();

  static HttpHelper? get instance => getInstance();
  static HttpHelper? getInstance() {
    dio ??= getDioInstance();
    http ??= HttpHelper();
    return http;
  }

  static Dio getDioInstance() {
    BaseOptions options = BaseOptions(
      baseUrl: _box.read('API_HOST'),
      responseType: ResponseType.json,
    );
    Dio dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers = {
            ...options.headers,
            "Authorization": _box.read('token') ?? "",
          };
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          var responseData = response.data;
          if (response.headers["content-type"] == "application/octet-stream") {
            return handler.resolve(response);
          }
          if (response.statusCode == 200) {
            if (responseData['code'] >= 2000 && responseData['code'] < 2010) {
              GETX.Get.snackbar('请求错误', responseData['msg']);
              if ([2000, 2002].contains(responseData['code'])) {
                // logout
              }
              return handler.reject(
                DioException(
                  requestOptions: RequestOptions(data: responseData),
                ),
              );
            }
          } else {
            return handler.reject(
              DioException(
                requestOptions: RequestOptions(data: response),
              ),
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  Future<Response<Map<String, dynamic>>> request(
      {String url = '',
      Method method = Method.GET,
      Map<String, dynamic>? query,
      Object? data,
      Map<String, dynamic>? headers}) {
    return dio!.request(
      url,
      data: data,
      queryParameters: query,
      options: Options(
        method: method.name,
        headers: headers ?? {},
      ),
    );
  }

  Future<BaseRes<T>> response<T>(
      Future<Response<Map<String, dynamic>>> req) async {
    Response<Map<String, dynamic>>? response = await req;
    if (response.statusCode == 200) {
      BaseRes<T> res = BaseRes.fromJson(response.data);
      return res;
    }
    throw Exception('${response.statusCode}+${response.statusMessage}');
  }

  Future<BaseRes<T>> get<T>(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) {
    return response<T>(
        request(url: url, query: params, headers: headers, method: Method.GET));
  }

  Future<BaseRes<T>> post<T>(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) {
    return response<T>(
        request(url: url, data: params, headers: headers, method: Method.POST));
  }

  Future<BaseRes<T>> put<T>(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) {
    return response<T>(
        request(url: url, data: params, headers: headers, method: Method.PUT));
  }

  Future<BaseRes<T>> delete<T>(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) {
    return response<T>(request(
        url: url, query: params, headers: headers, method: Method.DELETE));
  }
}

// ignore: constant_identifier_names
enum Method { GET, POST, PUT, DELETE }
