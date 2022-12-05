import 'package:dartz/dartz.dart';
import 'package:flutter_clean/core/error/failures.dart';
import 'package:flutter_clean/core/util/input_converter.dart';
import 'package:flutter_clean/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean/features/number_trivia/presentaion/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  final getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  final getRandomNumberTrivia = MockGetRandomNumberTrivia();
  final inputConverter = MockInputConverter();
  //late NumberTriviaBloc bloc;
  late NumberTriviaBloc bloc;

  setUp(() {
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: getConcreteNumberTrivia,
      getRandomNumberTrivia: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test', number: 1);

    registerFallbackValue(const Params(number: tNumberParsed));

    void setUpMockInputConverterSuccess() =>
        when(() => inputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    test('should call the InputConverter to convert', () async {
      setUpMockInputConverterSuccess();
      when(() => getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));
      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when input is invalid', () async {
      when(() => inputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [const Error(message: invalidInputFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete usecase', () async {
      setUpMockInputConverterSuccess();
      when(() => getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => getConcreteNumberTrivia(any()));
      verify(
          () => getConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded]', () async {
      setUpMockInputConverterSuccess();
      when(() => getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(() => getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with a proper message', () async {
      setUpMockInputConverterSuccess();
      when(() => getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
