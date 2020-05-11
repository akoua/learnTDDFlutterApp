import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number_new/core/error/exception.dart';
import 'package:trivia_number_new/core/error/failure.dart';
import 'package:trivia_number_new/features/data/models/number_trivia_models.dart';

abstract class TriviaNumberLocalDataSource {
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<TriviaNumberModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(TriviaNumberModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class TriviaNumberLocalDataSourceImpl implements TriviaNumberLocalDataSource {
  final SharedPreferences sharedPreferences;
  TriviaNumberLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(TriviaNumberModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<TriviaNumberModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      //Nous retournons ici un Future<TriviaNumberModel> déjà terminé
      return Future.value(TriviaNumberModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
