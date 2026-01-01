// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cellular_tower_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellularTowerModel _$CellularTowerModelFromJson(Map<String, dynamic> json) =>
    CellularTowerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isAccessible: json['isAccessible'] as bool,
      signalStrength: json['signalStrength'] as int,
      status: json['status'] as String,
      networkType: json['networkType'] as String?,
      pingLatency: json['pingLatency'] as int?,
      uploadSpeed: (json['uploadSpeed'] as num?)?.toDouble(),
      downloadSpeed: (json['downloadSpeed'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$CellularTowerModelToJson(
        CellularTowerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isAccessible': instance.isAccessible,
      'signalStrength': instance.signalStrength,
      'status': instance.status,
      'networkType': instance.networkType,
      'pingLatency': instance.pingLatency,
      'uploadSpeed': instance.uploadSpeed,
      'downloadSpeed': instance.downloadSpeed,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
