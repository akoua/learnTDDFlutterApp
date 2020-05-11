import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/error/exception.dart';
import 'package:trivia_number_new/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number_new/features/data/models/number_trivia_models.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttp;
  TriviaNumberRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    mockHttp = MockHttpClient();
    dataSourceImpl = TriviaNumberRemoteDataSourceImpl(httpClient: mockHttp);
  });
  void setUpMockHttpClientSuccess200() {
    when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Erreur xxx', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final triviaNumberModel =
        TriviaNumberModel.fromJson(json.decode(fixture("trivia.json")));

    test(
      "Nous ajoutons un entête de type application/json à la requête de type GET",
      () async {
        //Arrange
        // when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
        //     (_) async => http.Response(fixture("trivia.json"), 200));
        setUpMockHttpClientSuccess200();
        //Act
        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
        //Assert
        verify(mockHttp.get('http://numbersapi.com/$tNumber',
            headers: {'Content-Type': 'application/json'}));
      },
    );
    test(
      " Nous devons retourner un TriviaNumberModel quand l'appel à l'API est Ok avec un code 200",
      () async {
        //Arrange
        setUpMockHttpClientSuccess200();
        //Act
        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
        //Assert
        expect(result, equals(triviaNumberModel));
      },
    );
    test(
      "En cas de reponse autre que 200 nous devons lever une exception de type ServerException",
      () async {
        //Arrange
        setUpMockHttpClientFailure404();
        //Act
        final call = dataSourceImpl.getConcreteNumberTrivia;
        //Assert
        expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final triviaNumberModel =
        TriviaNumberModel.fromJson(json.decode(fixture("trivia.json")));

    test(
      "Nous ajoutons un entête de type application/json à la requête de type GET",
      () async {
        //Arrange
        // when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
        //     (_) async => http.Response(fixture("trivia.json"), 200));
        setUpMockHttpClientSuccess200();
        //Act
        final result = await dataSourceImpl.getRandomNumberTrivia();
        //Assert
        verify(mockHttp.get('http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'}));
      },
    );
    test(
      " Nous devons retourner un TriviaNumberModel quand l'appel à l'API est Ok avec un code 200",
      () async {
        //Arrange
        setUpMockHttpClientSuccess200();
        //Act
        final result = await dataSourceImpl.getRandomNumberTrivia();
        //Assert
        expect(result, equals(triviaNumberModel));
      },
    );
    test(
      "En cas de reponse autre que 200 nous devons lever une exception de type ServerException",
      () async {
        //Arrange
        setUpMockHttpClientFailure404();
        //Act
        final call = dataSourceImpl.getRandomNumberTrivia;
        //Assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
