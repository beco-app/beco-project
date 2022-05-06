import 'package:beco/Stores.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final storeList = await getMapStores();
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
          ),
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
      myLocationEnabled: false,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 12.0,
      ),
      markers: _markers.values.toSet(),
      myLocationButtonEnabled: true,
    );
  }
}
