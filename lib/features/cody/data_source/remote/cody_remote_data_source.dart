import 'package:ailook_flutter/features/cody/data_source/remote/models/item_model.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/models/cody_model.dart';

abstract interface class CodyRemoteDataSource {
  Future<ItemResponse> getItems();
  Future<CodyResponse> getCodies();
  Future<ItemModel> createItem(Map<String, dynamic> body);
  Future<ItemModel> updateItem(int id, Map<String, dynamic> body);
  Future<CodyModel> createCody(Map<String, dynamic> body);
  Future<CodyModel> updateCody(int id, Map<String, dynamic> body);
  Future<void> deleteItem(int id);
  Future<void> deleteCody(int id);
  Future<void> deleteUserAccount();
  Future<bool> toggleFavorite(int id);
}
