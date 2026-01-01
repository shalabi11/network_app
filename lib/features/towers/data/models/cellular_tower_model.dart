import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cellular_tower.dart';

part 'cellular_tower_model.g.dart';

@JsonSerializable()
class CellularTowerModel extends CellularTower {
  const CellularTowerModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.isAccessible,
    required super.signalStrength,
    required super.status,
    super.networkType,
    super.pingLatency,
    super.uploadSpeed,
    super.downloadSpeed,
    super.lastUpdated,
  });

  factory CellularTowerModel.fromJson(Map<String, dynamic> json) =>
      _$CellularTowerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CellularTowerModelToJson(this);

  factory CellularTowerModel.fromEntity(CellularTower tower) {
    return CellularTowerModel(
      id: tower.id,
      name: tower.name,
      latitude: tower.latitude,
      longitude: tower.longitude,
      isAccessible: tower.isAccessible,
      signalStrength: tower.signalStrength,
      status: tower.status,
      networkType: tower.networkType,
      pingLatency: tower.pingLatency,
      uploadSpeed: tower.uploadSpeed,
      downloadSpeed: tower.downloadSpeed,
      lastUpdated: tower.lastUpdated,
    );
  }

  CellularTower toEntity() {
    return CellularTower(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      isAccessible: isAccessible,
      signalStrength: signalStrength,
      status: status,
      networkType: networkType,
      pingLatency: pingLatency,
      uploadSpeed: uploadSpeed,
      downloadSpeed: downloadSpeed,
      lastUpdated: lastUpdated,
    );
  }
}
