import 'package:flutter/material.dart';
import 'package:neptune_app/common/util/latlng.dart';

const googleMapsApiKey = "AIzaSyCGmVc21YMGAOYTxivxQ2-J8govAzCbyqw";
const movingRouteServiceApiKey = "5b3ce3597851110001cf624868e687610694436f84bdad7f4bcc49a8";

const double earthRadiusMeter = 6371000;
final kmuttLatLng = LatLng(13.6507578, 100.4938778);

const parkingRefreshRate = Duration(seconds: 10);
const parkingMinimumStationarySpeed = 0.5; // m/s ???

const movingMaximumTimeBeforeAlertDefault = 10; // s
const movingMaximumVehicleRadius = 15000.0; // m
const movingMaximumSameRouteDeviation = 20.0; // m
const movingNotifierColorDefault = Colors.red;
const movingNotifierColorFrequencyDefault = 4.0; // Hz
const movingNotifierRefreshPeriod = 0.1; // s
