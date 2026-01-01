import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/error_widget.dart' as app_error;
import '../../domain/entities/cellular_tower.dart';
import '../bloc/tower_bloc.dart';
import '../bloc/tower_event.dart';
import '../bloc/tower_state.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);
  
  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  
  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadTowers();
  }
  
  Future<void> _requestPermissionAndLoadTowers() async {
    final status = await Permission.location.request();
    
    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
      }
    }
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
      });
      
      if (mounted) {
        context.read<TowerBloc>().add(
              LoadNearbyTowers(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }
  
  void _createMarkers(List<CellularTower> towers) {
    final markers = <Marker>{};
    
    for (final tower in towers) {
      markers.add(
        Marker(
          markerId: MarkerId(tower.id),
          position: LatLng(tower.latitude, tower.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            tower.isAccessible
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: tower.name,
            snippet: '${tower.signalStrength} dBm - ${tower.status}',
          ),
          onTap: () => _showTowerDetails(tower),
        ),
      );
    }
    
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
    });
  }
  
  void _showTowerDetails(CellularTower tower) {
    final languageCode = context.read<LanguageCubit>().state;
    final localizations = AppLocalizations(languageCode);
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tower.isAccessible ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    tower.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildDetailItem(
              Icons.signal_cellular_alt,
              localizations.signalStrength,
              '${tower.signalStrength} ${localizations.dbm}',
            ),
            _buildDetailItem(
              Icons.location_on,
              'Status',
              tower.isAccessible
                  ? localizations.accessible
                  : localizations.notAccessible,
            ),
            if (tower.networkType != null)
              _buildDetailItem(
                Icons.network_cell,
                'Network',
                tower.networkType!,
              ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<TowerBloc>().add(PingTowerEvent(tower.id));
                },
                icon: const Icon(Icons.network_ping),
                label: Text(localizations.pingTower),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LanguageCubit>().state;
    final localizations = AppLocalizations(languageCode);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.mapViewTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _currentPosition != null
                ? () {
                    _mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          zoom: 15,
                        ),
                      ),
                    );
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _currentPosition != null
                ? () {
                    context.read<TowerBloc>().add(
                          RefreshTowers(
                            latitude: _currentPosition!.latitude,
                            longitude: _currentPosition!.longitude,
                          ),
                        );
                  }
                : null,
          ),
        ],
      ),
      body: BlocConsumer<TowerBloc, TowerState>(
        listener: (context, state) {
          if (state is TowerLoaded) {
            _createMarkers(state.towers);
          } else if (state is TowerPinged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ping: ${state.latency}ms'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (_currentPosition == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is TowerError) {
            return app_error.ErrorWidget(
              message: state.message,
              onRetry: _getCurrentLocation,
            );
          }
          
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 15,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
