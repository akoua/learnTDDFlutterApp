part of 'trivia_number_bloc.dart';

@immutable
abstract class TriviaNumberState extends Equatable {}

class Empty extends TriviaNumberState {
  Empty() : super();
  @override
  List<Object> get props => [];
}

class Loading extends TriviaNumberState {
  Loading() : super();
  @override
  List<Object> get props => [];
}

class Loaded extends TriviaNumberState {
  final TriviaNumber triviaNumber;
  Loaded({this.triviaNumber}) : super();
  @override
  List<Object> get props => [triviaNumber];
}

class Error extends TriviaNumberState {
  final String message;
  Error({this.message}) : super();
  @override
  List<Object> get props => [message];
}
