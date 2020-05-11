import 'package:equatable/equatable.dart';

class TriviaNumber extends Equatable {
  final int number;
  final String text;

  TriviaNumber({this.number, this.text}) : super();

  @override
  List<Object> get props => [number, text];
}
