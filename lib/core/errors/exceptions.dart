import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception{

  const ServerException({required this.message,required this.statusCode});
  final String message;
  final dynamic statusCode;
  @override
  List<Object?> get props => [message,statusCode];
}

class CacheException extends Equatable implements Exception{

  const CacheException({required this.message,this.statusCode = 500});
  final String message;
  final int statusCode;
  @override
  List<Object?> get props => [message,statusCode];
}

class ConnectivityException extends Equatable implements Exception {
  const ConnectivityException({required this.message,this.statusCode = 500});
  final String message;
  final int statusCode;
  @override
  List<Object?> get props => [message];
}

class LivelinessException implements Exception {

  LivelinessException({required this.message,this.statusCode = 500});
  final String message;
  final int? statusCode;
}

class ScanDataException implements Exception {

  ScanDataException({required this.message,this.statusCode = 500});
  final String message;
  final int? statusCode;
}
