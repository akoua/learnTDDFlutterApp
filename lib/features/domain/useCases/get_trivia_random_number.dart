import 'package:trivia_number_new/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_number_new/core/useCase/trivia_use_case.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';
import 'package:trivia_number_new/features/domain/repositories/trivia_number_repository.dart';

class GetRandomTriviaNumber extends UseCase<TriviaNumber, NoParams> {
  final TriviaNumberRepository repository;
  GetRandomTriviaNumber({this.repository});

  @override
  Future<Either<Failure, TriviaNumber>> call(NoParams params) async {
    return await repository.getRandomTriviaNumber();
  }
}
