import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:neptune_app/common/util/latlng.dart';

class VehicleRepository {
  static const Duration _lifetime = Duration(minutes: 1);

  final FirebaseFirestore firestore;
  final Geoflutterfire geoflutterfire;

  VehicleRepository({required this.firestore, required this.geoflutterfire});

  Future<List<LatLng>?> getVehiclesInRadius({required double radius, required LatLng location}) async {
    var docs = await geoflutterfire
        .collection(collectionRef: firestore.collection('vehicles'))
        .within(center: location.toGeoFire(), radius: radius / 1000, field: 'location').first;

    var now = DateTime.now();
    var vehicles = docs
        .where((d) => DateTime.fromMillisecondsSinceEpoch(d['expires']).isAfter(now))
        .map((d) => d['location']['geopoint'] as GeoPoint)
        .map((p) => p.toCommonType())
        .toList();

    return vehicles;
  }

  Future<void> updateParkedVehicle({required User user, required LatLng location}) async {
    await firestore.collection('vehicles').doc(user.uid).set({
      'location': location.toGeoFire().data,
      'expires': DateTime.now().add(_lifetime).millisecondsSinceEpoch,
    });
  }

  Future<void> removeVehicle({required User user}) async {
    await firestore.collection('vehicles').doc(user.uid).delete();
  }
}
