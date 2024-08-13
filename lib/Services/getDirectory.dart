import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class getDirectory {
  Future<String> getdirectory() async{
    String directoryPath ="";
        AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    (deviceInfo.version.sdkInt < 33)
        ? (Directory((await getDownloadsDirectory())!.path).existsSync())
            ? directoryPath = (await getDownloadsDirectory())!.path
            : Directory((await getDownloadsDirectory())!.path)
                .create(recursive: true)
                .then((value) {
                directoryPath = value.path.toString();
              })
        : directoryPath = (await getApplicationSupportDirectory()).path;
    return directoryPath;
  }
}
