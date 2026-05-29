import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/network/app_dio.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/api/cody_api.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/models/item_model.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/models/cody_model.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/cody_remote_data_source.dart';

final class CodyRemoteDataSourceImpl implements CodyRemoteDataSource {
  final CodyAPI _codyAPI = CodyAPI(
    AppDio.instance,
    baseUrl: Flavor.apiUrl,
  );

  @override
  Future<ItemResponse> getItems() {
    return _codyAPI.getItems();
  }

  @override
  Future<CodyResponse> getCodies() {
    return _codyAPI.getCodies();
  }

  @override
  Future<ItemModel> createItem(Map<String, dynamic> body) {
    return _codyAPI.createItem(body);
  }

  @override
  Future<ItemModel> updateItem(int id, Map<String, dynamic> body) {
    return _codyAPI.updateItem(id, body);
  }

  @override
  Future<CodyModel> createCody(Map<String, dynamic> body) {
    return _codyAPI.createCody(body);
  }

  @override
  Future<CodyModel> updateCody(int id, Map<String, dynamic> body) {
    return _codyAPI.updateCody(id, body);
  }

  @override
  Future<void> deleteItem(int id) {
    return _codyAPI.deleteItem(id);
  }

  @override
  Future<void> deleteCody(int id) {
    return _codyAPI.deleteCody(id);
  }

  @override
  Future<void> deleteUserAccount() {
    return _codyAPI.deleteUserAccount();
  }

  @override
  Future<bool> toggleFavorite(int id) async {
    final response = await _codyAPI.toggleFavorite(id);
    return response.isFavorite;
  }
}
