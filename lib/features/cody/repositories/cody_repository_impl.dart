import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/item_entity.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/cody_entity.dart';
import 'package:ailook_flutter/features/cody/cody.dart';

class CodyRepositoryImpl implements CodyRepository {
  const CodyRepositoryImpl(this._codyRemoteDataSource);

  final CodyRemoteDataSource _codyRemoteDataSource;

  @override
  Future<Result<ItemListEntity>> getItems() async {
    try {
      final itemResponseModel = await _codyRemoteDataSource.getItems();
      return Result.success(ItemListEntity.fromModel(itemResponseModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<CodyListEntity>> getCodies() async {
    try {
      final codyResponseModel = await _codyRemoteDataSource.getCodies();
      return Result.success(CodyListEntity.fromModel(codyResponseModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<ItemEntity>> createItem(Map<String, dynamic> body) async {
    try {
      final itemModel = await _codyRemoteDataSource.createItem(body);
      return Result.success(ItemEntity.fromModel(itemModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<ItemEntity>> updateItem(int id, Map<String, dynamic> body) async {
    try {
      final itemModel = await _codyRemoteDataSource.updateItem(id, body);
      return Result.success(ItemEntity.fromModel(itemModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<CodyEntity>> createCody(Map<String, dynamic> body) async {
    try {
      final codyModel = await _codyRemoteDataSource.createCody(body);
      return Result.success(CodyEntity.fromModel(codyModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<CodyEntity>> updateCody(int id, Map<String, dynamic> body) async {
    try {
      final codyModel = await _codyRemoteDataSource.updateCody(id, body);
      return Result.success(CodyEntity.fromModel(codyModel));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
