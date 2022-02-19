import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_position_maps/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.68944, 139.69167),
    zoom: 14.4746,
  );

  static final Marker _kTokyoMarker = Marker(
      markerId: const MarkerId("_kTokyo"),
      infoWindow: const InfoWindow(title: "東京都"),
      icon: BitmapDescriptor.defaultMarker,
      position: const LatLng(35.68944, 139.69167),
      onTap: () {});

  static const CameraPosition _kKanagawa = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(35.44778, 139.6425),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Marker _kKanagawaMarker = Marker(
    markerId: MarkerId("kanagawa"),
    infoWindow: InfoWindow(title: "世田谷"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(35.646544, 139.6532351),
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: {
        Marker(
            markerId: const MarkerId("_kTokyo"),
            infoWindow: const InfoWindow(title: "東京都"),
            icon: BitmapDescriptor.defaultMarker,
            position: const LatLng(35.68944, 139.69167),
            onTap: () {
              setState(() {
                _settingModalBottomSheet(
                    context, "assets/tokyo.jpg", "東京心すぽ", "少年Aの殺害");
              });
            }),
        _kKanagawaMarker
      },
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kKanagawa));
  }

  void _settingModalBottomSheet(
      context, String image, String name, String details) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        elevation: 30,
        constraints: const BoxConstraints(
            minHeight: double.infinity, minWidth: double.infinity),
        builder: (BuildContext bc) {
          return Column(
            children: [
              buildHeader(context),
              Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.hotel_outlined,
                                      color: Colors.white)),
                              Text("0")
                            ],
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: _share,
                              icon:
                                  Icon(Icons.more_horiz, color: Colors.white))),
                      Image.asset(image),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 2,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.details,
                        color: Colors.red,
                      ),
                      title: const Text(
                        '詳細',
                        style: TextStyle(color: Colors.grey),
                      ),
                      subtitle: Text(details,
                          style: const TextStyle(color: Colors.red)),
                    ),
                    ListTile(
                        leading: const Icon(
                          Icons.chat_bubble_outline_sharp,
                          color: Colors.white,
                        ),
                        title: const Text(
                          '掲示板919',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: keizibanURL),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget buildHeader(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                width: 70,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> keizibanURL() async => await canLaunch(keiziban)
      ? await launch(keiziban)
      : throw 'Could not launch $keiziban';

  void _share() => Share.share("ここ行かない？");
}
