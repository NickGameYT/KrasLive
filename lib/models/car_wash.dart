import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CarWashStatus {
  free,      // Зеленый - свободная
  moderate,  // Желтый - относительно свободная
  busy       // Красный - загруженная
}

class CarWash {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final int minPrice;
  final CarWashStatus status;
  final String address;
  final String phone;

  const CarWash({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.minPrice,
    required this.status,
    required this.address,
    required this.phone,
  });

  Color get statusColor {
    switch (status) {
      case CarWashStatus.free:
        return Colors.green;
      case CarWashStatus.moderate:
        return Colors.yellow;
      case CarWashStatus.busy:
        return Colors.red;
    }
  }

  BitmapDescriptor get markerIcon {
    switch (status) {
      case CarWashStatus.free:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case CarWashStatus.moderate:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case CarWashStatus.busy:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  String get statusText {
    switch (status) {
      case CarWashStatus.free:
        return 'Свободно';
      case CarWashStatus.moderate:
        return 'Средняя загруженность';
      case CarWashStatus.busy:
        return 'Высокая загруженность';
    }
  }
} 