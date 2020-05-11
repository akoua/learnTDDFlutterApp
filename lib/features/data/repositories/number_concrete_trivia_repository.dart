import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/trivia_number.dart';
import '../../domain/repositories/trivia_number_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

//Nous créeons une fonction que nous appelerons
typedef Future<TriviaNumber> _ConcreteOrRandomChooser();

class TriviaNumberRepositoryImpl implements TriviaNumberRepository {
  final TriviaNumberRemoteDataSource remoteDataSource;
  final TriviaNumberLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  TriviaNumberRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, TriviaNumber>> getConcretTriviaNumber(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, TriviaNumber>> getRandomTriviaNumber() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
    // if (await networkInfo.isConnected) {
    //   try {
    //     final remoteRandomTrivia =
    //         await remoteDataSource.getRandomNumberTrivia();
    //     localDataSource.cacheNumberTrivia(remoteRandomTrivia);
    //     return Right(remoteRandomTrivia);
    //   } on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   try {
    //     final localRandomTrivia = await localDataSource.getLastNumberTrivia();
    //     return Right(localRandomTrivia);
    //   } on CacheException {
    //     return Left(CacheFailure());
    //   }
    // }
  }

  Future<Either<Failure, TriviaNumber>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRandomTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteRandomTrivia);
        return Right(remoteRandomTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRandomTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localRandomTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
