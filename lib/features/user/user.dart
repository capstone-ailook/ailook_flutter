import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/features/user/data_source/remote/user_remote_data_source.dart';
import 'package:ailook_flutter/features/user/repositories/user_repository.dart';
import 'package:ailook_flutter/features/user/usecases/get_user_profile_use_case.dart';
import 'package:ailook_flutter/features/user/usecases/submit_user_profile_use_case.dart';

export 'data_source/remote/user_remote_data_source.dart';
export 'data_source/remote/user_remote_data_source_impl.dart';
export 'repositories/user_repository.dart';
export 'repositories/user_repository_impl.dart';
export 'repositories/entities/user_profile_entity.dart';
export 'usecases/get_user_profile_use_case.dart';
export 'usecases/submit_user_profile_use_case.dart';

final userRemoteDataSource = locator<UserRemoteDataSource>();
final userRepository = locator<UserRepository>();
final getUserProfileUseCase = locator<GetUserProfileUseCase>();
final submitUserProfileUseCase = locator<SubmitUserProfileUseCase>();
