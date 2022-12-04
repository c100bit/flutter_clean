// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connection;

  NetworkInfoImpl(this.connection);

  @override
  Future<bool> get isConnected async =>
      (await connection.checkConnectivity()) != ConnectivityResult.none;
}
