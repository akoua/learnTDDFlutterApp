import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/useCase/trivia_use_case.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';
import 'package:trivia_number_new/features/domain/repositories/trivia_number_repository.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_concret_number.dart';

class MockTriviaNumberRepository extends Mock
    implements TriviaNumberRepository {}

main() {
  MockTriviaNumberRepository mockTriviaNumberRepository;
  GetConcretNumberTrivia useCase;

  int tNumber = 1;
  TriviaNumber triviaNumber = TriviaNumber(number: 1, text: "test");

  setUp(() {
    mockTriviaNumberRepository = MockTriviaNumberRepository();
    useCase = GetConcretNumberTrivia(repository: mockTriviaNumberRepository);
  });
  test("Nous allons tester le repository à travers la useCase Concret",
      () async {
    //print(mockTriviaNumberRepository);
    when(mockTriviaNumberRepository.getConcretTriviaNumber(any))
        .thenAnswer((_) async => Right(triviaNumber));
    // when(mockTriviaNumberRepository.getConcretTriviaNumber(any))
    //     .thenAnswer((_) async {
    //   return Right(triviaNumber);
    // });
    final result = await useCase(Params(number: tNumber));
    // print(Right(result));

    expect(result, Right(triviaNumber));
    verify(mockTriviaNumberRepository.getConcretTriviaNumber(tNumber));
    verifyNoMoreInteractions(mockTriviaNumberRepository);
  });
}
