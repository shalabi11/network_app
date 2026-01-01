import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart' as app_error;
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/tower_card.dart';
import '../../domain/entities/cellular_tower.dart';
import '../bloc/tower_bloc.dart';
import '../bloc/tower_event.dart';
import '../bloc/tower_state.dart';
import '../../../settings/presentation/cubit/language_cubit.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  Position? _currentPosition;
  String? _expandedTowerId;

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  List<CellularTower> _sortTowers(List<CellularTower> towers) {
    if (_currentPosition == null) return towers;

    final sortedTowers = List<CellularTower>.from(towers);
    sortedTowers.sort((a, b) {
      final distanceA = a.distanceFrom(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      final distanceB = b.distanceFrom(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return sortedTowers;
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LanguageCubit>().state;
    final localizations = AppLocalizations(languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.listViewTitle),
        actions: [
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
          if (state is TowerPinged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${localizations.pingLatency}: ${state.latency}${localizations.ms}',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TowerLoading) {
            return const TowerListShimmer();
          }

          if (state is TowerError) {
            return app_error.ErrorWidget(
              message: state.message,
              onRetry: _getCurrentLocation,
              retryText: localizations.retry,
            );
          }

          if (state is TowerLoaded || state is TowerPinged) {
            final towers = state is TowerLoaded 
                ? state.towers 
                : (state as TowerPinged).towers;
            
            if (towers.isEmpty) {
              return EmptyStateWidget(
                message: localizations.noTowers,
                onRetry: _getCurrentLocation,
                retryText: localizations.retry,
              );
            }

            final sortedTowers = _sortTowers(towers);

            return RefreshIndicator(
              onRefresh: () async {
                if (_currentPosition != null) {
                  context.read<TowerBloc>().add(
                    RefreshTowers(
                      latitude: _currentPosition!.latitude,
                      longitude: _currentPosition!.longitude,
                    ),
                  );
                }
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: sortedTowers.length,
                itemBuilder: (context, index) {
                  final tower = sortedTowers[index];
                  final isExpanded = _expandedTowerId == tower.id;

                  return TowerCard(
                    tower: tower,
                    showDetails: isExpanded,
                    userLatitude: _currentPosition?.latitude,
                    userLongitude: _currentPosition?.longitude,
                    onTap: () {
                      setState(() {
                        _expandedTowerId = isExpanded ? null : tower.id;
                      });
                    },
                    onPing: () {
                      context.read<TowerBloc>().add(PingTowerEvent(tower.id));
                    },
                  );
                },
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
