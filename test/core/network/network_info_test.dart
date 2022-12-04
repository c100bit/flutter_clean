import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_clean/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnection extends Mock implements Connectivity {}

void main() {
  final mockConnection = MockConnection();
  final networkInfo = NetworkInfoImpl(mockConnection);

  group('isConnected', (() {
    test('should forward the call to checkConnectivity', (() async {
      when(() => mockConnection.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);
      final result = await networkInfo.isConnected;
      verify(mockConnection.checkConnectivity);
      expect(result, equals(true));
    }));
  }));
}
