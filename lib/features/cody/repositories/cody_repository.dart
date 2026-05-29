import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/item_entity.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/cody_entity.dart';

abstract interface class CodyRepository {
  Future<Result<ItemListEntity>> getItems();
  Future<Result<CodyListEntity>> getCodies();
  Future<Result<ItemEntity>> createItem(Map<String, dynamic> body);
  Future<Result<ItemEntity>> updateItem(int id, Map<String, dynamic> body);
  Future<Result<CodyEntity>> createCody(Map<String, dynamic> body);
  Future<Result<CodyEntity>> updateCody(int id, Map<String, dynamic> body);
  Future<Result<void>> deleteItem(int id);
  Future<Result<void>> deleteCody(int id);
  Future<Result<void>> deleteUserAccount();
  Future<Result<bool>> toggleFavorite(int id);
}
