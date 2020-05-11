import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number_new/core/error/exception.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/features/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number_new/features/data/models/number_trivia_models.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

TriviaNumberLocalDataSourceImpl triviaNumberLocalDataSourceImpl;
MockSharedPreferences mockSharedPreferences;

void main() {
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    triviaNumberLocalDataSourceImpl = TriviaNumberLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final triviaNumber =
        TriviaNumberModel.fromJson(json.decode(fixture("trivia_cached.json")));
    test(
      "Nous devrions retourner un NumberTrivia provenant de SharePreferences du cache quand " +
          "cette dernière en possède",
      () async {
        //Arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture("trivia_cached.json"));
        //Act
        final result =
            await triviaNumberLocalDataSourceImpl.getLastNumberTrivia();
        //Assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, triviaNumber);
      },
    );
    test(
      "Nous lançons une exception quand il n'y a pas de données dans le cache",
      () async {
        //Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //Act
        final call = triviaNumberLocalDataSourceImpl.getLastNumberTrivia;
        //Assert
        // expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    test(
      "Nous devrions rajouter un objet NumberTriviaModel dans le cache",
      () async {
        final triviaNumberModel =
            TriviaNumberModel(number: 1, text: "Text test");
        //Arrange
        //Act
        await triviaNumberLocalDataSourceImpl
            .cacheNumberTrivia(triviaNumberModel);
        //Assert
        final expectedJsonString = json.encode(triviaNumberModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
