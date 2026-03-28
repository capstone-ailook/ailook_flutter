import 'dart:io';
import 'package:ailook_flutter/features/media/data_source/remote/api/media_api.dart';
import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:dio/dio.dart';

abstract class MediaRepository {
  Future<Result<String>> uploadImage(File image);
}

class MediaRepositoryImpl implements MediaRepository {
  final MediaAPI _api;

  MediaRepositoryImpl(this._api);

  @override
  Future<Result<String>> uploadImage(File image) async {
    try {
      final res = await _api.uploadImage(image);
      return Result.success(res.imageUrl);
    } on DioException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}
