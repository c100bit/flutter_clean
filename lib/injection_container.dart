import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_clean/core/network/network_info.dart';
import 'package:flutter_clean/core/util/input_converter.dart';
import 'package:flutter_clean/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean/features/number_trivia/presentaion/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  // Uses cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
