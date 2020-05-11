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
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';

/**
 * Nous définissons d'abord les mocks qui seront nécessaires à l'éxecution de notre test
 */
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
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repositoryImpl = TriviaNumberRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcretTriviaNumber', () {
    //Données à utiliser tout au long du test
    final tNumber = 1;
    final tTriviaNumberModel = TriviaNumberModel(number: 1, text: 'test Text');
    final TriviaNumber tTriviaNumber = tTriviaNumberModel;
    test(
      "vérifions que la propriété isConnected a été appelée",
      () async {
        //Arrange
        //voulons nous rassurer que l'appel à la propriété isConnected est parfaitement appelé
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //Act
        repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        //On vérifie ici que c'est le cas
        print(mockNetworkInfo.isConnected);
        verify(mockNetworkInfo.isConnected);
      },
    );
  });

  group('device est en ligne', () {
    final tNumber = 1;
    final tTriviaNumberModel = TriviaNumberModel(number: 1, text: 'test Text');

    // This setUp applies only to the 'device is online' group
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test(
      "retourner la data provenant de l'API si la connexion d'avec l'API est est établie",
      () async {
        //Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tTriviaNumberModel);
        //Act
        final result = await repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tTriviaNumberModel)));
      },
    );
    test(
      "insérer la data dans le cache si l'accès à l'API c'est fait avec succès",
      () async {
        //Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tTriviaNumberModel);
        //Act
        await repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        //Nous voulons vérifier que la methode de mise en cache a été au moins appélée
        verify(mockLocalDataSource.cacheNumberTrivia(tTriviaNumberModel));
      },
    );

    test(
      "Gestion des erreurs ServerException lorsque nous sommes en ligne",
      () async {
        //Arrange
        //Nous simulons une exception de type ServerException
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        //Act
        final result = await repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        //Nous vérifions que le type de result est véritablement ServerFailure car ce que nous
        //ramenerons dans la couche domaine
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group('device offline', () {
    final tNumber = 1;
    final tTriviaNumberModel = TriviaNumberModel(number: 1, text: 'test Text');
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
      "Nous récuperons la dernière data mise en cache",
      () async {
        //Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tTriviaNumberModel);
        //Act
        //Notons que c'est ladite méthode qui contient la logique à tester donc il faut l'appelé
        final result = await repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        //Vérifier que ladite méthodes a été appelé
        verify(mockLocalDataSource.getLastNumberTrivia());
        //Nous voulons vérifier qu'en mode hors ligne nous ne faisons pas appel à l'API
        verifyZeroInteractions(mockRemoteDataSource);
        //Nous vérifions que le result et notre solution de test ont le même type
        //à savoir Either<<Failure>, <TriviaNumber>>
        expect(result, equals(Right(tTriviaNumberModel)));
      },
    );
    test(
      "Capture de l'exception CacheException au cas ou il n'y a pas de data dans le cache",
      () async {
        //Arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //Act
        final result = await repositoryImpl.getConcretTriviaNumber(tNumber);
        //Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
