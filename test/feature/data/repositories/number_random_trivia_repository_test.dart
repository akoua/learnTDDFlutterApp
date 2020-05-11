import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/error/exception.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/core/network/network_info.dart';
import 'package:trivia_number_new/features/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number_new/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number_new/features/data/models/number_trivia_models.dart';
import 'package:trivia_number_new/features/data/repositories/number_concrete_trivia_repository.dart';

class MockRemoteDataSource extends Mock
    implements TriviaNumberRemoteDataSource {}

class MockLocalDataSource extends Mock implements TriviaNumberLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  TriviaNumberRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = TriviaNumberRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device est ligne', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device est hors ligne', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getRandomTriviaNumber', () {
    final tTriviaNumberModel = TriviaNumberModel(number: 1, text: 'test Text');
    final tNumber = 1;
    // test(
    //   "Vérifions si le téléphone est connecté à Internet",
    //   () async {
    //     //Arrange
    //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //     //Act
    //     repositoryImpl.getRandomTriviaNumber();
    //     //Assert
    //     verify(mockNetworkInfo.isConnected);
    //   },
    // );
    runTestsOnline(() {
      test(
        "Nous recuperons la data provenant de l'API",
        () async {
          //Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tTriviaNumberModel);
          //Act
          final result = await repositoryImpl.getRandomTriviaNumber();
          //Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tTriviaNumberModel)));
        },
      );
      test(
        "Nous mettons en cache la data provenant de l'API",
        () async {
          //Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tTriviaNumberModel);
          //Act
          final result = await repositoryImpl.getRandomTriviaNumber();
          //Assert
          verify(mockLocalDataSource.cacheNumberTrivia(tTriviaNumberModel));
        },
      );
      test(
        "Nous transformons l'exception ServerException en ServerFailure pour la couche domaine",
        () async {
          //Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //Act
          final actual = await repositoryImpl.getRandomTriviaNumber();
          //Assert
          expect(actual, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        "Nous recuperons la dernière data dans le cache",
        () async {
          //Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tTriviaNumberModel);
          //Act
          final result = await repositoryImpl.getRandomTriviaNumber();
          //Assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Right(tTriviaNumberModel));
        },
      );

      test(
        "Nous transformons l'exception CaheException en CacheFailure pour la couche domaine",
        () async {
          //Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //Act
          final actual = await repositoryImpl.getRandomTriviaNumber();
          //Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(actual, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
