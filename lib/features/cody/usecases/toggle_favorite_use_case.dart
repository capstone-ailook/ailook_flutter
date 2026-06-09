import 'package:ailook_flutter/core/modules/base_use_case/base_use_case.dart';
import 'package:ailook_flutter/core/modules/error_handling/result.dart';
import 'package:ailook_flutter/features/cody/repositories/cody_repository.dart';

class ToggleFavoriteUseCase extends BaseUseCase<int, Result<bool>> {
  final CodyRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  @override
  Future<Result<bool>> call([int? params]) {
    return _repository.toggleFavorite(params!);
  }
}
