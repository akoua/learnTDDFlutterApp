part of 'trivia_number_bloc.dart';

@immutable
abstract class TriviaNumberEvent extends Equatable {}

class GetConcreteTriviaNumberEvent extends TriviaNumberEvent {
  final String numberString;
  GetConcreteTriviaNumberEvent({this.numberString}) : super();

  @override
  List<Object> get props => [numberString];
}

class GetRandomTriviaNumberEvent extends TriviaNumberEvent {
  GetRandomTriviaNumberEvent() : super();

  @override
  List<Object> get props => [];
}
