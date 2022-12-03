import 'dart:convert';

import 'package:flutter_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test');

  test('should be a subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON number is an integer', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when JSON number is a double', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map', () {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {"text": "Test", "number": 1};
      expect(result, expectedMap);
    });
  });
}
