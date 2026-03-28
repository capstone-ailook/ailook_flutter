import 'package:dio/dio.dart' hide Headers;
import 'package:ailook_flutter/features/cody/data_source/remote/models/item_model.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/models/cody_model.dart';
import 'package:retrofit/retrofit.dart';

part 'cody_api.g.dart';

@RestApi()
abstract class CodyAPI {
  factory CodyAPI(Dio dio, {String baseUrl}) = _CodyAPI;

  @GET("/items/")
  @Headers({"requiresToken": true})
  Future<ItemResponse> getItems();

  @GET("/codies/")
  @Headers({"requiresToken": true})
  Future<CodyResponse> getCodies();

  @POST("/items/")
  @Headers({"requiresToken": true})
  Future<ItemModel> createItem(@Body() Map<String, dynamic> body);

  @PATCH("/items/{id}/")
  @Headers({"requiresToken": true})
  Future<ItemModel> updateItem(@Path("id") int id, @Body() Map<String, dynamic> body);

  @POST("/codies/")
  @Headers({"requiresToken": true})
  Future<CodyModel> createCody(@Body() Map<String, dynamic> body);

  @PATCH("/codies/{id}/")
  @Headers({"requiresToken": true})
  Future<CodyModel> updateCody(@Path("id") int id, @Body() Map<String, dynamic> body);
}
