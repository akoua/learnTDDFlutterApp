import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/core/util/input_converter.dart';

void main() {
  group('InputConverter', () {
    InputConverter inputConverter;
    setUp(() {
      inputConverter = InputConverter();
    });
    test(
      "La valeur entré est un nombre entier non signé",
      () async {
        //Arrange
        final str = '123';
        //Act
        final result = inputConverter.stringToUnsignedInteger(str);
        //Assert
        expect(result, Right(str));
      },
    );
    test(
      "La valeur rentrée est tout sauf un nombre ",
      () async {
        //Arrange
        final str = 'abc';
        //Act
        final result = inputConverter.stringToUnsignedInteger(str);
        //Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      "Nous retournons une exception si l'utilisateur entre un nombre negatif",
      () async {
        // arrange
        final str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
