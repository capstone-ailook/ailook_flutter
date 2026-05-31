import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/core/modules/base_use_case/base_no_param_use_case.dart';
import 'package:ailook_flutter/features/cody/repositories/cody_repository.dart';
import 'package:ailook_flutter/features/cody/repositories/entities/item_entity.dart';

final class GetItemsUseCase extends BaseNoParamUseCase<Result<ItemListEntity>> {
  GetItemsUseCase(this._codyRepository);

  final CodyRepository _codyRepository;

  @override
  Future<Result<ItemListEntity>> call() {
    return _codyRepository.getItems();
  }
}
