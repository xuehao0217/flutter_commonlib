
import 'dart:io';

import 'package:common_core/base/base_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

///https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler_android/example/android/app/src/main/AndroidManifest.xml
class PermissionHandlerWidget extends StatefulWidget {
  @override
  _PermissionHandlerWidgetState createState() =>
      _PermissionHandlerWidgetState();
}
class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
          children: Permission.values
              .where((permission) {
            if (Platform.isIOS) {
              return permission != Permission.unknown &&
                  permission != Permission.phone &&
                  permission != Permission.sms &&
                  permission != Permission.ignoreBatteryOptimizations &&
                  permission != Permission.accessMediaLocation &&
                  permission != Permission.activityRecognition &&
                  permission != Permission.manageExternalStorage &&
                  permission != Permission.systemAlertWindow &&
                  permission != Permission.requestInstallPackages &&
                  permission != Permission.accessNotificationPolicy &&
                  permission != Permission.bluetoothScan &&
                  permission != Permission.bluetoothAdvertise &&
                  permission != Permission.bluetoothConnect &&
                  permission != Permission.nearbyWifiDevices &&
                  permission != Permission.videos &&
                  permission != Permission.audio &&
                  permission != Permission.scheduleExactAlarm &&
                  permission != Permission.sensorsAlways;
            } else {
              return permission != Permission.unknown &&
                  permission != Permission.mediaLibrary &&
                  permission != Permission.photosAddOnly &&
                  permission != Permission.reminders &&
                  permission != Permission.bluetooth &&
                  permission != Permission.appTrackingTransparency &&
                  permission != Permission.criticalAlerts &&
                  permission != Permission.assistant;
            }
          })
              .map((permission) => PermissionWidget(permission))
              .toList()),
    );
  }
}

/// Permission widget containing information about the passed [Permission]
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission]
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: (_permission is PermissionWithService)
          ? IconButton(
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            checkServiceStatus(
                context, _permission);
          })
          : null,
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(
      BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}