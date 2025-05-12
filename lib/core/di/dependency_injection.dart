import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:support/core/helpers/auth_helpers/auth_interceptor.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/auth/confirmation/data/repos/confirmation_repo.dart';
import 'package:support/features/auth/confirmation/data/services/confirmation_api_service.dart';
import 'package:support/features/auth/confirmation/logic/cubit/confirmation_cubit.dart';
import 'package:support/features/auth/forgetpassword/data/repos/forgetpassword_repo.dart';
import 'package:support/features/auth/forgetpassword/data/services/forgetpassword_api_service.dart';
import 'package:support/features/auth/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:support/features/auth/login/data/repos/login_repo.dart';
import 'package:support/features/auth/login/data/services/login_api_service.dart';
import 'package:support/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:support/features/auth/signup/data/repos/register_repo.dart';
import 'package:support/features/auth/signup/data/services/register_api_service.dart';
import 'package:support/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: /*'http://10.0.2.2:3000/api'*/ "https://optexeg.me/api/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  getIt.registerLazySingleton<AuthService>(() => AuthService(storage, dio));

  dio.interceptors.add(AuthInterceptor(getIt<AuthService>(), dio));

  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<LoginApiService>(
      () => LoginApiService(getIt<Dio>()));

  getIt.registerLazySingleton<LoginRepo>(
      () => LoginRepo(getIt<LoginApiService>()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));

  getIt.registerLazySingleton<RegisterApiService>(
      () => RegisterApiService(getIt<Dio>()));

  getIt.registerLazySingleton<RegisterRepo>(
      () => RegisterRepo(getIt<RegisterApiService>()));
  getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(getIt<RegisterRepo>()));

  getIt.registerLazySingleton<ForgetPasswordApiService>(
      () => ForgetPasswordApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(apiService: getIt<ForgetPasswordApiService>()));

  getIt.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(repository: getIt<ForgetPasswordRepo>()));

  // Confirmation feature
  getIt.registerLazySingleton<ConfirmationApiService>(
    () => ConfirmationApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<EmailConfirmationRepo>(
    () => EmailConfirmationRepo(getIt<ConfirmationApiService>()),
  );

  getIt.registerFactory<EmailConfirmationCubit>(
    () => EmailConfirmationCubit(getIt<EmailConfirmationRepo>()),
  );

 getIt.registerLazySingleton<SupportApiService>(
    () => SupportApiService(getIt<Dio>()),
  );

}
