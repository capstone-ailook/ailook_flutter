import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:ailook_flutter/app/network/interceptors/logger_interceptor.dart';
import 'package:ailook_flutter/app/network/interceptors/token_interceptor.dart';
import 'package:flutter/foundation.dart';

/**
 *  네트워크 패키지 [Dio] 관련 설정
 *  compute 메소드를 적용하여 별도의 스레드에서 네트워크 통신을 할 수 있도록 함.
 *  로그 인터셉터 및 토큰 인터셉터 로직 적용
 * */

abstract class AppDio {
  AppDio._internal();

  static Dio? _instance;

  static Dio get instance => _instance ??= _AppDio();
}

class _AppDio with DioMixin implements Dio {
  _AppDio() {
    httpClientAdapter = IOHttpClientAdapter();
    options = BaseOptions(
      connectTimeout: Duration(milliseconds: 30000),
      // RAG 코디 추천은 BGE-M3 + Gemini 2콜로 수~십수 초 걸릴 수 있음
      receiveTimeout: Duration(milliseconds: 120000),
      sendTimeout: Duration(milliseconds: 60000),
      receiveDataWhenStatusError: true,
    );

    transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;

    interceptors.addAll([
      TokenInterceptor(),
      LoggerInterceptor(),
    ]);
  }
}

// compute 메소드 적용
// 최상단 메소드에서 실행
// compute 함수 내부 에러 핸들링 추가
_parseAndDecode(String response) {
  try {
    return jsonDecode(response);
  } catch (e) {
    throw Exception('Failed to parse JSON');
  }
}

// compute 함수가 메모리 누수를 발생시키지 않도록 수정
Future<dynamic> parseJson(String text) async {
  return compute(_parseAndDecode, text);
}