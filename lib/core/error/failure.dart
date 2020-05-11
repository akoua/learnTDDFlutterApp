import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  Failure({this.properties}) : super();

  @override
  List<Object> get props => [properties];
}

//General failure
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NoLocalDataFailure extends Failure {}

class InvalidInputFailure extends Failure {}
