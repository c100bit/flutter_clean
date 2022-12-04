import 'dart:convert';

import 'package:flutter_clean/core/error/exceptions.dart';
import 'package:flutter_clean/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final mockHttpClient = MockHttpClient();
  final dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  registerFallbackValue(Uri());

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  group('getConcreteNumberTrivia', (() {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL', (() async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(() => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    }));
    test('should return NumberTrivia when 200', (() async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    }));

    test('should throw a ServerException when code is  404', (() async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Wrong', 404));

      final call = dataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    }));
  }));
}
