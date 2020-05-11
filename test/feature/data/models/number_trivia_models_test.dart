import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number_new/features/data/models/number_trivia_models.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tTriviaNumberModel = TriviaNumberModel(number: 1, text: "test Text");

  group('fromJson', () {
    test(
      "Test de la méthode fromJson",
      () async {
        //Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture("trivia_double.json"));
        //Act
        final result = TriviaNumberModel.fromJson(jsonMap);
        // print(result.number);
        //Assert
        // expect(tTriviaNumberModel, isA<TriviaNumber>());
        expect(result, tTriviaNumberModel);
      },
    );
  });

  group('toJson', () {
    test(
      "Test de la methode toJson",
      () async {
        //Arrange
        //Act
        final result = tTriviaNumberModel.toJson();
        final expectedJsonMap = {"text": "test Text", "number": 1};
        //Assert
        expect(result, expectedJsonMap);
      },
    );
  });
}
