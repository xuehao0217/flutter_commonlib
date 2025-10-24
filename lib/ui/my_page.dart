import 'package:common_core/base/base_stateful_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends BaseStatefulWidget<MyPage> {
  @override
  Color setStatusBarColor() => Colors.deepPurpleAccent;

  @override
  String setTitle() => "我的";

  @override
  bool showTitleBar() => false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      // deviceData = switch (defaultTargetPlatform) {
      //   TargetPlatform.android =>
      //       _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      //   TargetPlatform.iOS =>
      //       _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
      //   TargetPlatform.fuchsia => throw UnimplementedError(),
      //   TargetPlatform.linux => throw UnimplementedError(),
      //   TargetPlatform.macOS => throw UnimplementedError(),
      //   TargetPlatform.windows => throw UnimplementedError(),
      // };
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,

    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  String _getAppBarTitle() => kIsWeb
      ? 'Web Browser info'
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => 'Android Device Info',
          TargetPlatform.iOS => 'iOS Device Info',
          TargetPlatform.linux => 'Linux Device Info',
          TargetPlatform.windows => 'Windows Device Info',
          TargetPlatform.macOS => 'MacOS Device Info',
          TargetPlatform.fuchsia => 'Fuchsia Device Info',
        };

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  Widget buildPageContent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    double physicalScreenWidth = screenWidth * devicePixelRatio;
    double physicalScreenHeight = screenHeight * devicePixelRatio;
    print("buildPageContent----screenWidth==${screenWidth}  screenHeight=${screenHeight}  physicalScreenWidth=${physicalScreenWidth}   physicalScreenHeight==${physicalScreenHeight}");
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        elevation: 4,
      ),
      body: ListView(
        children: _deviceData.keys.map(
          (String property) {
            return Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    property,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${_deviceData[property]}',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
