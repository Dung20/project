import 'package:neptune_app/common/util/route_util.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math' as math;

import 'package:neptune_app/common/util/location_util.dart';
import 'package:neptune_app/common/util/latlng.dart';

void main() {
  test('earthSurfaceDistance', () {
    expect(LocationUtil.earthSurfaceDistance(
        LatLng(13.650064851177058, 100.49094687812247),
        LatLng(13.647208160454293, 100.49567828431569)
    ), equalsEpsilon(600, 5));
  });
  test('earthToUnit3D and unit3DToEarth', () {
    expectLatLng3DConv(LatLng(0, 0), Vector3(1, 0, 0));
    expectLatLng3DConv(LatLng(0, 90), Vector3(0, 1, 0));
    expectLatLng3DConv(LatLng(0, 180), Vector3(-1, 0, 0));
    expectLatLng3DConv(LatLng(0, -180), Vector3(-1, 0, 0));
    expectLatLng3DConv(LatLng(0, 360), Vector3(1, 0, 0));

    expectLatLng3DConv(LatLng(90, 0), Vector3(0, 0, 1));
    expectLatLng3DConv(LatLng(-90, 0), Vector3(0, 0, -1));

    // Invalid coordinates
    expectVector3(LocationUtil.earthToUnit3D(LatLng(90, 100)), Vector3(0, 0, 1));
  });
  test('greatCircleNormal', () {
    expectVector3(LocationUtil.greatCircleNormal(
        start: LatLng(0, 0),
        end: LatLng(0, 90)
    ), Vector3(0, 0, 1));

    expectVector3(LocationUtil.greatCircleNormal(
        start: LatLng(0, 0),
        end: LatLng(90, 0)
    ), Vector3(0, -1, 0));
  });
  test('greatCircleProjection', () {
    expectLatLng(LocationUtil.greatCircleProjection(
        start: LatLng(0, 0),
        end: LatLng(0, 90),
        point: LatLng(60, 45)
    ), LatLng(0, 45));

    expectLatLng(LocationUtil.greatCircleProjection(
        start: LatLng(0, 90),
        end: LatLng(0, 0),
        point: LatLng(60, 45)
    ), LatLng(0, 45));

    expectLatLng(LocationUtil.greatCircleProjection(
        start: LatLng(30, 0),
        end: LatLng(-10, 0),
        point: LatLng(0, 90)
    ), LatLng(0, 0));

    expectLatLng(LocationUtil.greatCircleProjection(
        start: LatLng(45, 0),
        end: LatLng(-45, 0),
        point: LatLng(45, 90)
    ), LatLng(90, 0));
  });
  test('isProjectionInside', () {
    expect(LocationUtil.isProjectionInside(
        start: LatLng(0, 0),
        end: LatLng(0, 90),
        proj: LatLng(0, 45)
    ), isTrue);

    expect(LocationUtil.isProjectionInside(
        start: LatLng(0, 0),
        end: LatLng(0, 90),
        proj: LatLng(0, -45)
    ), isFalse);

    expect(LocationUtil.isProjectionInside(
        start: LatLng(0, 0),
        end: LatLng(0, 90),
        proj: LatLng(1, 45)
    ), isFalse);

    expect(LocationUtil.isProjectionInside(
        start: LatLng(0, 0),
        end: LatLng(90, 0),
        proj: LatLng(45, 0)
    ), isTrue);
  });
  test('calculateRouteLength', () {
    expect(RouteUtil.calculateRouteLength([
      LatLng(0, 0),
      LatLng(0, 45),
      LatLng(0, 45),
      LatLng(0, 90),
      LatLng(0, -90),
    ]), equalsEpsilon(LocationUtil.earthRadiusMeter * math.pi * 3 / 2, 1e-5));

    expect(RouteUtil.calculateRouteLength([
      LatLng(0, 0),
      LatLng(45, 0),
      LatLng(45, 0),
      LatLng(90, 90),
      LatLng(0, 180),
    ]), equalsEpsilon(LocationUtil.earthRadiusMeter * math.pi, 1e-5));
  });
  test('routeToEndAt', () {
    testRouteToEndAt([
      LatLng(0, 0),
      LatLng(0, 45),
      LatLng(0, 90),
      LatLng(0, 135),
      LatLng(0, 180),
    ], LatLng(0, 100), LocationUtil.earthRadiusMeter, [
      LatLng(0, 0),
      LatLng(0, 45),
      LatLng(0, 90),
      LatLng(0, 100),
    ]);

    testRouteToEndAt([
      LatLng(-45, 0),
      LatLng(0, 0),
      LatLng(45, 0),
      LatLng(80, 0),
      LatLng(90, 0),
    ], LatLng(60, 0), LocationUtil.earthRadiusMeter, [
      LatLng(-45, 0),
      LatLng(0, 0),
      LatLng(45, 0),
      LatLng(60, 0),
    ]);
  });
}

void testRouteToEndAt(List<LatLng> route, LatLng end, double maxDist, List<LatLng>? expected) {
  var newRouteNull = RouteUtil.routeToEndAt(route: route, end: end, maxDist: maxDist);

  if (expected == null || newRouteNull == null) {
    expect(newRouteNull, equals(expected));
    return;
  }

  var newRoute = newRouteNull;

  expect(newRoute.length, equals(expected.length));

  for (var i = 0; i < newRoute.length; i++) {
    expectLatLng(newRoute[i], expected[i]);
  }
}

void expectLatLng3DConv(LatLng latLng, Vector3 vec) {
  expectVector3(LocationUtil.earthToUnit3D(latLng), vec);
  expectLatLng(LocationUtil.unit3DToEarth(vec), latLng);
}

void expectVector3(Vector3 a, Vector3 b) {
  expect(a.x, equalsEpsilon(b.x, 1e-5));
  expect(a.y, equalsEpsilon(b.y, 1e-5));
  expect(a.z, equalsEpsilon(b.z, 1e-5));
}

void expectLatLng(LatLng a, LatLng b) {
  expect(a.latitude, equalsEpsilon(b.latitude, 1e-5));
  expect(a.longitude, equalsEpsilon(b.longitude, 1e-5));
}

Matcher equalsEpsilon(double target, double epsilon) {
  return inInclusiveRange(target - epsilon, target + epsilon);
}