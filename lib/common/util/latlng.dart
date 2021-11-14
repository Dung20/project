import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps;
import 'package:location/location.dart';

class LatLng extends Equatable {
  final GoogleMaps.LatLng _inner;

  get latitude => _inner.latitude;
  get longitude => _inner.longitude;

  LatLng(double latitude, double longitude) : _inner = GoogleMaps.LatLng(latitude, longitude);
  LatLng.fromGoogleMaps(GoogleMaps.LatLng latLng) : _inner = latLng;

  @override
  List<Object> get props => [latitude, longitude];

  GoogleMaps.LatLng toGoogleMapsType() {
    return _inner;
  }

  GeoFirePoint toGeoFire() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension CommonLatLngToGoogleMapsList on List<LatLng> {
  List<GoogleMaps.LatLng> toGoogleMapsType() {
    return map((e) => e.toGoogleMapsType()).toList();
  }
}

extension CommonLatLngExtensionGoogleMaps on GoogleMaps.LatLng {
  LatLng toCommonType() {
    return LatLng.fromGoogleMaps(this);
  }
}

extension CommonLatLngExtensionLocationData on LocationData {
  LatLng? toCommonType() {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }
}

extension CommonLatLangExtensionGeoflutterFire on GeoFirePoint {
  LatLng toCommonType() {
    return LatLng(latitude, longitude);
  }
}

extension CommonLatLangExtensionGeoPoint on GeoPoint {
  LatLng toCommonType() {
    return LatLng(latitude, longitude);
  }
}
