import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/app/di/feature_di_interface.dart';
import 'package:ailook_flutter/features/user/user.dart';

final class UserDependencyInjection extends FeatureDependencyInjection {
  @override
  void dataSources() {
    locator.registerLazySingleton<UserRemoteDataSource>(
      UserRemoteDataSourceImpl.new,
    );
  }

  @override
  void repositories() {
    locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        userRemoteDataSource,
      ),
    );
  }

  @override
  void useCases() {
    locator
      ..registerFactory(
        () => GetUserProfileUseCase(
          userRepository,
        ),
      )
      ..registerFactory(
        () => SubmitUserProfileUseCase(
          userRepository,
        ),
      );
  }
}