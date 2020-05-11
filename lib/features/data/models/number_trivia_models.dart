import 'package:flutter/foundation.dart';

import '../../domain/entities/trivia_number.dart';

class TriviaNumberModel extends TriviaNumber {
  final int number;
  final String text;

  TriviaNumberModel({@required this.number, @required this.text})
      : super(number: number, text: text);

/**
 * Permet de passer d'un Objet JSON à un Objet du type TriviaNumberModel
 */
  factory TriviaNumberModel.fromJson(Map<String, dynamic> jsonMap) {
    return TriviaNumberModel(
        number: (jsonMap['number'] as num).toInt(), text: jsonMap['text']);
  }

  /*
   * Nous permet de passer d'un objet à un fichier JSON
   */
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
