import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/useCase/trivia_use_case.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';
import 'package:trivia_number_new/features/domain/repositories/trivia_number_repository.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_random_number.dart';

class MockTriviaRepository extends Mock implements TriviaNumberRepository {}

main() {
  MockTriviaRepository mockTriviaRepository;
  GetRandomTriviaNumber useCase;

  setUp(() {
    mockTriviaRepository = MockTriviaRepository();
    useCase = GetRandomTriviaNumber(repository: mockTriviaRepository);
  });

  TriviaNumber triviaNumber = TriviaNumber(number: 1, text: "test");
  test(
    "Test getRandomTriviaNumber() de TriviaNumberRepository",
    () async {
      //When
      //Nous attendons dans la droite du resultat triviaNumber
      when(mockTriviaRepository.getRandomTriviaNumber())
          .thenAnswer((_) async => Right(triviaNumber));
      //Act
      final result = await useCase(NoParams());
      // final result = useCase(NoParams()).then((value) => value);
      // print(Right(result));
      // sleep(const Duration(seconds: 5));
      // print(Right(result));
      //Assert
      expect(result, Right(triviaNumber));
      verify(mockTriviaRepository.getRandomTriviaNumber());
      verifyNoMoreInteractions(mockTriviaRepository);
    },
  );
}
