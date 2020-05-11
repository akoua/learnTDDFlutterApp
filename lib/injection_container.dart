import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/data/datasources/number_trivia_local_data_source.dart';
import 'features/data/datasources/number_trivia_remote_data_source.dart';
import 'features/data/repositories/number_concrete_trivia_repository.dart';
import 'features/domain/repositories/trivia_number_repository.dart';
import 'features/domain/useCases/get_trivia_random_number.dart';
import 'features/presentation/bloc/bloc/trivia_number_bloc.dart';
import 'package:http/http.dart' as http;

import 'features/domain/useCases/get_trivia_concret_number.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! Features - Trivia Number
  //BLoC
  //ici j'ai une nouvelle instance à tout appel
  sl.registerFactory<TriviaNumberBloc>(() =>
      TriviaNumberBloc(concrete: sl(), random: sl(), inputConverter: sl()));
  //UseCases
  sl.registerLazySingleton(() => GetConcretNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomTriviaNumber(repository: sl()));
  //Repository
  sl.registerLazySingleton<TriviaNumberRepository>(() =>
      TriviaNumberRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  //Data Sources
  sl.registerLazySingleton<TriviaNumberRemoteDataSource>(
      () => TriviaNumberRemoteDataSourceImpl(httpClient: sl()));
  sl.registerLazySingleton<TriviaNumberLocalDataSource>(
      () => TriviaNumberLocalDataSourceImpl(sharedPreferences: sl()));
  //! Core
  //inputConverter
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => sharedPreferences);
}
