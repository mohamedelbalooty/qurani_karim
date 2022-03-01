import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return BuildLoadingWidget();
          if (snapshot.data.enabled == true) {
            switch (snapshot.data.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return QiblahCompassWidget();
              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: "location_denied".tr(),
                  callback: _checkLocationStatus,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: "location_denied".tr(),
                  callback: _checkLocationStatus,
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: 'enable_location'.tr(),
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else
      _locationStreamController.sink.add(locationStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }
}

class QiblahCompassWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return BuildLoadingWidget();

        final qiblahDirection = snapshot.data;

        return FadeInRight(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: ((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/qibla_compass.png',
                    fit: BoxFit.fill,
                    height: 250,
                    width: 250,
                    alignment: Alignment.center,
                  ),
                ),
                bigVerticalSpace(),
                Text(
                  "${qiblahDirection.offset.toStringAsFixed(3)}°",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LocationErrorWidget extends StatelessWidget {
  final String error;
  final Function callback;

  const LocationErrorWidget({Key key, this.error, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.location_off,
              size: 150.0,
              color: whiteColor,
            ),
            bigVerticalSpace(),
            Text(
              error ?? '',
              style: Theme.of(context).textTheme.headline2,
            ),
            bigVerticalSpace(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: Text(
                'retry'.tr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () {
                if (callback != null) callback();
              },
            )
          ],
        ),
      ),
    );
  }
}
