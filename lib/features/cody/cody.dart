import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/core/index.dart';
import 'package:ailook_flutter/features/cody/data_source/remote/cody_remote_data_source.dart';
import 'package:ailook_flutter/features/cody/repositories/cody_repository.dart';
import 'package:ailook_flutter/features/cody/usecases/get_codies_use_case.dart';
import 'package:ailook_flutter/features/cody/usecases/get_items_use_case.dart';
export 'package:ailook_flutter/core/modules/error_handling/result.dart';
export 'package:ailook_flutter/core/modules/base_use_case/base_use_case.dart';
export 'package:ailook_flutter/core/modules/base_use_case/base_no_param_use_case.dart';

export 'data_source/remote/cody_remote_data_source.dart';
export 'data_source/remote/cody_remote_data_source_impl.dart';
export 'data_source/remote/models/item_model.dart';
export 'data_source/remote/models/cody_model.dart';
export 'repositories/cody_repository.dart';
export 'repositories/cody_repository_impl.dart';
export 'repositories/entities/item_entity.dart';
export 'repositories/entities/cody_entity.dart';
export 'usecases/get_items_use_case.dart';
export 'usecases/get_codies_use_case.dart';

final codyRemoteDataSource = locator<CodyRemoteDataSource>();
final codyRepository = locator<CodyRepository>();
final getItemsUseCase = locator<GetItemsUseCase>();
final getCodiesUseCase = locator<GetCodiesUseCase>();
