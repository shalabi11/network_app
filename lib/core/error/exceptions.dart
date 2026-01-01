class ServerException implements Exception {
  final String message;
  
  ServerException([this.message = 'Server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  
  CacheException([this.message = 'Cache error occurred']);
}

class LocationException implements Exception {
  final String message;
  
  LocationException([this.message = 'Location error occurred']);
}

class PermissionException implements Exception {
  final String message;
  
  PermissionException([this.message = 'Permission denied']);
}
