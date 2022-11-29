import 'package:latlong2/latlong.dart';

class GeoLocation {
  final String name;
  final String address;
  final LatLng latlng;

  GeoLocation({
    required this.name,
    required this.address,
    required this.latlng,
  });

  @override
  String toString(){
    return "{Name: $name, Address: $address, Latlng: $latlng}";
  }
}
// final mapMarkers = [
//   GeoLocation(
//       name: 'Alexander The Great Restaurant',
//       address: '8 Plender St, London NW1 0JT, United Kingdom',
//       latlng: LatLng(51.5382123, -0.1882464),
//   ),
//   GeoLocation(
//       name: 'Mestizo Mexican Restaurant',
//       address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
//       latlng: LatLng(51.5090229, -0.2886548),
//   ),
//   GeoLocation(
//       name: 'The Shed',
//       address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
//       latlng: LatLng(51.5090215, -0.1959988),
//   ),
//   GeoLocation(
//       name: 'Gaucho Tower Bridge',
//       address: '2 More London Riverside, London SE1 2AP, United Kingdom',
//       latlng: LatLng(51.5054563, -0.0798412),
//   ),
//   GeoLocation(
//     name: 'Bill\'s Holborn Restaurant',
//     address: '42 Kingsway, London WC2B 6EY, United Kingdom',
//     latlng: LatLng(51.5077676, -0.2208447),
//   ),
// ];
