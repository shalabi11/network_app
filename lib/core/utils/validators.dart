class Validators {
  static bool isValidLatitude(double latitude) {
    return latitude >= -90 && latitude <= 90;
  }

  static bool isValidLongitude(double longitude) {
    return longitude >= -180 && longitude <= 180;
  }

  static bool isValidSignalStrength(int strength) {
    return strength >= -120 && strength <= 0; // dBm
  }

  static bool isValidPingTime(int milliseconds) {
    return milliseconds >= 0 && milliseconds <= 10000;
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
