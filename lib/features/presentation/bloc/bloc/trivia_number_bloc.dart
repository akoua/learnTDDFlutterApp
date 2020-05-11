import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/core/useCase/trivia_use_case.dart';
import 'package:trivia_number_new/core/util/input_converter.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_concret_number.dart';
import 'package:trivia_number_new/features/domain/useCases/get_trivia_random_number.dart';

part 'trivia_number_event.dart';
part 'trivia_number_state.dart';

final String SERVER_FAILURE_MESSAGE = 'Erreur Serveur';
final String CACHE_FAILURE_MESSAGE = 'Erreur Cache';
final String INVALID_INPUT_FAILURE_MESSAGE =
    'Entrée invalide - Le nombre entré doit être un entier positif ou zéro.';

class TriviaNumberBloc extends Bloc<TriviaNumberEvent, TriviaNumberState> {
  final GetRandomTriviaNumber getRandomTriviaNumber;
  final GetConcretNumberTrivia getConcretNumberTrivia;
  final InputConverter inputConverter;

  TriviaNumberBloc(
      {@required GetConcretNumberTrivia concrete,
      @required GetRandomTriviaNumber random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcretNumberTrivia = concrete,
        getRandomTriviaNumber = random;

  @override
  TriviaNumberState get initialState => Empty();

  @override
  Stream<TriviaNumberState> mapEventToState(
    TriviaNumberEvent event,
  ) async* {
    if (event is GetConcreteTriviaNumberEvent) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold(
          //Nous gérons l'erreur avec la fonction lambda contenant failure
          (failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      },
          //Nous gérons le cas succès avec la fonction lambda contenant integer
          (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcretNumberTrivia(Params(number: integer));
        // yield failureOrTrivia.fold(
        //     (failure) => Error(
        //           message: _mapFailureToMessage(failure),
        //         ),
        //     (trivia) => Loaded(triviaNumber: trivia));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetRandomTriviaNumberEvent) {
      print('rentré hein');
      yield Loading();
      final failureOrTrivia = await getRandomTriviaNumber(
        NoParams(),
      );
      // yield failureOrTrivia.fold(
      //   (failure) => Error(message: _mapFailureToMessage(failure)),
      //   (trivia) => Loaded(triviaNumber: trivia),
      // );
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<TriviaNumberState> _eitherLoadedOrErrorState(
    Either<Failure, TriviaNumber> either,
  ) async* {
    yield either.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(triviaNumber: trivia),
    );
  }

  _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Erreur inattendue";
    }
  }
}
