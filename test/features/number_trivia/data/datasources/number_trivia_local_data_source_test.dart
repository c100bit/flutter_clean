import 'package:flutter_clean/core/error/exceptions.dart';
import 'package:flutter_clean/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final dataSource =
      NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  group('getLastNumberTrivia', (() {
    test(
        'should return NumberTrivia from SharedPreferenses when one is present',
        (() async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      final result = await dataSource.getLastNumberTrivia();
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    }));
    test('should throw a CacheException when NumberTrivia is not present',
        (() async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    }));
  }));

  group('cacheNumberTrivia', (() {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test');

    test('should call  SharedPreferenses to cache data', (() async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      final value = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(cachedNumberTrivia, value));
    }));
  }));
}
