import 'dart:io';
import 'package:ailook_flutter/features/media/data_source/remote/models/media_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'media_api.g.dart';

@RestApi()
abstract class MediaAPI {
  factory MediaAPI(Dio dio, {String baseUrl}) = _MediaAPI;

  @POST('/upload/image/')
  @MultiPart()
  Future<MediaUploadResponse> uploadImage(
    @Part(name: 'image') File image,
  );
}
