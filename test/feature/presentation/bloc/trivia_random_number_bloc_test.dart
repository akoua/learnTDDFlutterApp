import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/core/useCase/trivia_use_case.dart';
import 'package:trivia_number_new/core/util/input_converter.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_concret_number.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_random_number.dart';
import 'package:trivia_number_new/features/presentation/bloc/bloc/trivia_number_bloc.dart';

class MockGetTriviaConcreteNumber extends Mock
    implements GetConcretNumberTrivia {}

class MockGetTriviaRandomNumber extends Mock implements GetRandomTriviaNumber {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetTriviaConcreteNumber mockGetTriviaConcreteNumber;
  MockGetTriviaRandomNumber mockGetTriviaRandomNumber;
  MockInputConverter mockInputConverter;
  TriviaNumberBloc triviaNumberBloc;

  setUp(() {
    mockGetTriviaConcreteNumber = MockGetTriviaConcreteNumber();
    mockGetTriviaRandomNumber = MockGetTriviaRandomNumber();
    mockInputConverter = MockInputConverter();

    triviaNumberBloc = TriviaNumberBloc(
        concrete: mockGetTriviaConcreteNumber,
        random: mockGetTriviaRandomNumber,
        inputConverter: mockInputConverter);
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = TriviaNumber(number: 1, text: 'text test');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetTriviaRandomNumber(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        triviaNumberBloc.add(GetRandomTriviaNumberEvent());
        await untilCalled(mockGetTriviaRandomNumber(any));
        // assert
        verify(mockGetTriviaRandomNumber(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetTriviaRandomNumber(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(triviaNumber: tNumberTrivia),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc.add(GetRandomTriviaNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetTriviaRandomNumber(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc.add(GetRandomTriviaNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetTriviaRandomNumber(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc.add(GetRandomTriviaNumberEvent());
      },
    );
  });
}
