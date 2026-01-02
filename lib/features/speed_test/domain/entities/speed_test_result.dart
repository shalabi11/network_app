import 'package:equatable/equatable.dart';

class SpeedTestResult extends Equatable {
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isDownloading;
  final bool isUploading;
  final bool isDone;
  final String? error;

  const SpeedTestResult({
    this.downloadSpeed = 0.0,
    this.uploadSpeed = 0.0,
    this.isDownloading = false,
    this.isUploading = false,
    this.isDone = false,
    this.error,
  });

  SpeedTestResult copyWith({
    double? downloadSpeed,
    double? uploadSpeed,
    bool? isDownloading,
    bool? isUploading,
    bool? isDone,
    String? error,
  }) {
    return SpeedTestResult(
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      isDownloading: isDownloading ?? this.isDownloading,
      isUploading: isUploading ?? this.isUploading,
      isDone: isDone ?? this.isDone,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    downloadSpeed,
    uploadSpeed,
    isDownloading,
    isUploading,
    isDone,
    error,
  ];
}
