import 'package:ailook_flutter/app/di/app_binding.dart';
import 'package:ailook_flutter/app/di/feature_di_interface.dart';
import 'package:ailook_flutter/app/environment/flavor.dart';
import 'package:ailook_flutter/app/network/app_dio.dart';
import 'package:ailook_flutter/features/media/repositories/media_repository.dart';
import 'package:ailook_flutter/features/media/data_source/remote/api/media_api.dart';

final class MediaDependencyInjection extends FeatureDependencyInjection {
  @override
  void dataSources() {
    safeRegisterSingleton<MediaAPI>(
      () => MediaAPI(AppDio.instance, baseUrl: Flavor.apiUrl),
    );
  }

  @override
  void repositories() {
    safeRegisterSingleton<MediaRepository>(
      () => MediaRepositoryImpl(locator<MediaAPI>()),
    );
  }

  @override
  void useCases() {}
}
