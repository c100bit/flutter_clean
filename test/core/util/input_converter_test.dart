import 'package:dartz/dartz.dart';
import 'package:flutter_clean/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final inputConverter = InputConverter();

  group('stringToUnsigned', () {
    test('should return an integer when the string ', () {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, const Right(123));
    });

    test('should return a failure', () {
      const str = 'abc';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure', () {
      const str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
