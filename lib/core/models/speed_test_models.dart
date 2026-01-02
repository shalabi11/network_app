/// Enumeration for speed units
enum SpeedUnit { Kbps, Mbps }
/// Speed test result data class
class SpeedTestData {
  final double downloadSpeed;
  final double uploadSpeed;
  final double ping;
  final String serverName;
  final String country;

  SpeedTestData({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.serverName,
    required this.country,
  });
}
/// Callback typedef for speed test progress
typedef OnSpeedTestProgress =
    Function(double percent, double transferRate, SpeedUnit unit);

/// Callback typedef for speed test completion
typedef OnSpeedTestDone = Function(double transferRate, SpeedUnit unit);

/// Callback typedef for speed test error
typedef OnSpeedTestError = Function(String errorMessage, String speedTestError);
