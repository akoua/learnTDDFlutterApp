import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../../../core/useCase/trivia_use_case.dart';
import '../entities/trivia_number.dart';
import '../repositories/trivia_number_repository.dart';

class GetConcretNumberTrivia extends UseCase<TriviaNumber, Params> {
  final TriviaNumberRepository repository;

  GetConcretNumberTrivia({this.repository});

  @override
  Future<Either<Failure, TriviaNumber>> call(Params params) async {
    return await repository.getConcretTriviaNumber(params.number);
  }

  // Future<Either<Failure, TriviaNumber>> call({@required int number}) async {
  //   // print(number);
  //   return await repository.getConcretTriviaNumber(number);
  // }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number}) : super();

  @override
  List<Object> get props => [number];
}
