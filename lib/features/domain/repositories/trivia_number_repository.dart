import 'package:dartz/dartz.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';

abstract class TriviaNumberRepository {
  Future<Either<Failure, TriviaNumber>> getConcretTriviaNumber(int number);
  Future<Either<Failure, TriviaNumber>> getRandomTriviaNumber();
}
