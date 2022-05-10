import 'package:beco/Stores.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'DetailView.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Map<String, Marker> _markers = {};
  late final Position position;
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final storeList = await getMapStores();
    position = await _determinePosition();
    setState(() {
      _markers.clear();
      for (final store in storeList.stores) {
        print(store.lat);
        final marker = Marker(
          markerId: MarkerId(store.shopname),
          position: LatLng(store.lat, store.lng),
          infoWindow: InfoWindow(
              title: store.shopname,
              snippet: store.address,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailView.routeName,
                  arguments: store,
                );
              }),
        );
        _markers[store.shopname] = marker;
      }
    });
  }

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(41.387378, 2.170659);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 12.0,
      ),
      markers: _markers.values.toSet(),
      myLocationButtonEnabled: true,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
