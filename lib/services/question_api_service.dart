import 'dart:io';

import 'package:dio/dio.dart';

import '../models/search_response.dart';

class QuestionApiService {
  QuestionApiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<SearchResponse> uploadImage({
    required String baseUrl,
    required File imageFile,
  }) async {
    final url = _composeUploadUrl(baseUrl);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });

    try {
      final response = await _dio.post<dynamic>(
        url,
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SearchResponse.fromJson(data);
      }
      throw const ApiException('后端返回格式不正确，请检查接口返回 JSON。');
    } on DioException catch (error) {
      throw ApiException(_toReadableError(error));
    }
  }

  String _composeUploadUrl(String baseUrl) {
    final normalized = baseUrl.trim();
    if (normalized.isEmpty) {
      throw const ApiException('请先填写后端地址。');
    }

    final withoutSlash = normalized.replaceFirst(RegExp(r'/+$'), '');
    return '$withoutSlash/upload';
  }

  String _toReadableError(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      if (detail != null) {
        return detail.toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return '请求超时，请检查网络或后端服务状态。';
    }

    if (error.type == DioExceptionType.connectionError) {
      return '连接失败，请确认后端地址可访问。';
    }

    return error.message ?? '上传失败，请稍后重试。';
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
