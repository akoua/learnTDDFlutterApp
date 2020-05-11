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

  group('TriviaNumberBloc', () {
    //l'évènement produit
    final numberString = '1';
    //la valeur correcte renvoyée par InputConverter
    final numberParsed = int.parse(numberString);
    //Une instance NumberTrivia
    final numberTrivia = TriviaNumber(number: 1, text: "Text test");

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(numberParsed));

    test(
      "L'état initial doit être Empty",
      () async {
        //Arrange
        //Act
        //Assert
        expect(triviaNumberBloc.initialState, equals(Empty()));
      },
    );
    test(
      "Nous vérifions que la valeur envoyée par InputConverter est correcte",
      () async {
        //Arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(numberParsed));
        //Act
        //nous créeons l'event responsable de l'execution de la logique
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
        //On se rassure de faire appel à la métjode avant la vérification sinon ça sera une erreur
        await untilCalled(
            mockInputConverter.stringToUnsignedInteger(numberString));
        //Assert
        verify(mockInputConverter.stringToUnsignedInteger(numberString));
      },
    );
    test(
      "Nous devons générer [Error] quand l'entrée est invalide",
      () async {
        //Arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenThrow(Left(InvalidInputFailure()));
        //Assert After
        final expect = [
          //C'est appelé dans l'ordre
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expect));
        await untilCalled(mockGetTriviaConcreteNumber(any));
        //Act
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
      },
    );
    test(
      "Nous devons obtenir des données concrètes du UseCase GetConcretNumberTrivia",
      () async {
        //Arrange
        setUpMockInputConverterSuccess();
        when(mockGetTriviaConcreteNumber(any))
            .thenAnswer((_) async => Right(numberTrivia));
        //Act
        //On envoie un event
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
        //on applique la logique à éxecuter
        await untilCalled(mockGetTriviaConcreteNumber(any));
        //Assert
        verify(mockGetTriviaConcreteNumber(Params(number: numberParsed)));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetTriviaConcreteNumber(any))
            .thenAnswer((_) async => Right(numberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(triviaNumber: numberTrivia),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
      },
    );
    test(
      "Nous devons emettre une erreur de type ServerFailure lorsque nous avons [Loading, Error]",
      () async {
        //Arrange
        setUpMockInputConverterSuccess();
        when(mockGetTriviaConcreteNumber(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
      },
    );

    test(
      "Nous devons emettre une erreur de type CacheFailure lorsque nous avons [Loading, Error]",
      () async {
        //Arrange
        setUpMockInputConverterSuccess();
        when(mockGetTriviaConcreteNumber(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(triviaNumberBloc, emitsInOrder(expected));
        // act
        triviaNumberBloc
            .add(GetConcreteTriviaNumberEvent(numberString: numberString));
      },
    );
  });
}
