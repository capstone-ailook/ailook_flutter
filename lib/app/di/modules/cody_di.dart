import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/app/di/feature_di_interface.dart';
import 'package:ailook_flutter/features/cody/cody.dart';

final class CodyDependencyInjection extends FeatureDependencyInjection {
  @override
  void dataSources() {
    locator.registerLazySingleton<CodyRemoteDataSource>(
      CodyRemoteDataSourceImpl.new,
    );
  }

  @override
  void repositories() {
    locator.registerLazySingleton<CodyRepository>(
      () => CodyRepositoryImpl(
        codyRemoteDataSource,
      ),
    );
  }

  @override
  void useCases() {
    locator
      ..registerFactory(
        () => GetItemsUseCase(
          codyRepository,
        ),
      )
      ..registerFactory(
        () => GetCodiesUseCase(
          codyRepository,
        ),
      )
      ..registerFactory(
        () => ToggleFavoriteUseCase(
          codyRepository,
        ),
      );
  }
}
