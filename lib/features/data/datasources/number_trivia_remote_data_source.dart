import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/exception.dart';
import '../models/number_trivia_models.dart';

abstract class TriviaNumberRemoteDataSource {
  Future<TriviaNumberModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TriviaNumberModel> getRandomNumberTrivia();
}

class TriviaNumberRemoteDataSourceImpl implements TriviaNumberRemoteDataSource {
  final http.Client httpClient;
  TriviaNumberRemoteDataSourceImpl({@required this.httpClient});

  @override
  Future<TriviaNumberModel> getConcreteNumberTrivia(int number) async {
    // final response = await httpClient.get('http://numbersapi.com/$number',
    //     headers: {'Content-Type': 'application/json'});
    // if (response.statusCode == 200) {
    //   return TriviaNumberModel.fromJson(json.decode(response.body));
    // } else {
    //   throw ServerException();
    // }
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<TriviaNumberModel> getRandomNumberTrivia() async {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<TriviaNumberModel> _getTriviaFromUrl(String url) async {
    final response = await httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return TriviaNumberModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
