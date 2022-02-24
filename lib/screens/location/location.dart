import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wazzaf/cubit/career/career_cubit.dart';
import 'package:wazzaf/cubit/career/career_states.dart';

class Location extends StatelessWidget {
  Location({Key? key}) : super(key: key);
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Position? currentPoistion;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0.0;
  void locatePoistion(CareerCubit cCubit) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPoistion = position;
    // cCubit.locationFuction();

    // LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    // CameraPosition cameraPosition =
    //     CameraPosition(target: latLngPosition, zoom: 14);
    // newGoogleMapController!.
    //     animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareerCubit, CareerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var _cubit = CareerCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                key: scaffoldKey,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: const Text('موقع العامل'),
                ),
                body: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _cubit.kGooglePlex!,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: Set.from(_cubit.myMarker),
                      // onTap: _cubit.handleTap,
                      onMapCreated: (GoogleMapController controller) {
                        _controllerGoogleMap.complete(controller);
                        newGoogleMapController = controller;
                        locatePoistion(_cubit);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// class _LocationState extends State<Location> {
//   void locatePoistion() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(msg: 'Please enable Your Location Service');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Fluttertoast.showToast(msg: 'Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//           msg:
//               'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     currentPoistion = position;
//     // LatLng latLngPosition = LatLng(position.latitude, position.longitude);
//     // CameraPosition cameraPosition =
//     //     CameraPosition(target: latLngPosition, zoom: 14);
//     // newGoogleMapController!.
//     //     animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   }

//   CameraPosition _kGooglePlex = const CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         key: scaffoldKey,
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           title: const Text('موقع العامل'),
//         ),
//         body: Stack(
//           children: [
//             GoogleMap(
//               // padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
//               initialCameraPosition: _kGooglePlex,
//               mapType: MapType.normal,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               zoomControlsEnabled: true,
//               zoomGesturesEnabled: true,
//               onMapCreated: (GoogleMapController controller) {
//                 _controllerGoogleMap.complete(controller);
//                 newGoogleMapController = controller;
//                 locatePoistion();
//                 // setState(() {
//                 //   bottomPaddingOfMap = 265.0;
//                 // });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
