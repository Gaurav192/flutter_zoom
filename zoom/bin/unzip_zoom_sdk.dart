import 'dart:core';
import 'dart:io';
import 'dart:convert';

//import 'package:dio/dio.dart';

void main(List<String> args) async {
  var location = Platform.script.toString();
  var isNewFlutter = location.contains(".snapshot");
  if (isNewFlutter) {
    var sp = Platform.script.toFilePath();
    var sd = sp.split(Platform.pathSeparator);
    sd.removeLast();
    var scriptDir = sd.join(Platform.pathSeparator);
    var packageConfigPath = [scriptDir, '..', '..', '..', 'package_config.json']
        .join(Platform.pathSeparator);
    // print(packageConfigPath);
    var jsonString = File(packageConfigPath).readAsStringSync();
    // print(jsonString);
    Map<String, dynamic> packages = jsonDecode(jsonString);
    var packageList = packages["packages"];
    String? zoomFileUri;
    for (var package in packageList) {
      if (package["name"] == "zoom") {
        //replace ../ to fix path issue for local dependency
        zoomFileUri = package["rootUri"].replaceFirst("../", "");
        break;
      }
    }
    if (zoomFileUri == null) {
      print("zoom package not found!");
      return;
    }
    location = zoomFileUri;
  }
  if (Platform.isWindows) {
    location = location.replaceFirst("file:///", "");
  } else {
    location = location.replaceFirst("file://", "");
  }
  if (!isNewFlutter)
    location = location.replaceFirst("/bin/unzip_zoom_sdk.dart", "");
  // var filename =
  //     location + '/ios-sdk/MobileRTC${(args.length == 0) ? "" : "-dev"}.zip';

  await checkAndDownloadSDK(location);
  // print('Decompressing ' + filename);

  // final bytes = File(filename).readAsBytesSync();

  // final archive = ZipDecoder().decodeBytes(bytes);

  // var current = new File(location + '/ios/MobileRTC.framework/MobileRTC');
  // var exist = await current.exists();
  // if (exist) current.deleteSync();

  // for (final file in archive) {
  //   final filename = file.name;
  //   if (file.isFile) {
  //     final data = file.content as List<int>;
  //     File(location + '/ios/MobileRTC.framework/' + filename)
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(data);
  //   }
  // }

  print('Complete');
}

Future<void> checkAndDownloadSDK(String location) async {
  if (Platform.isMacOS) {
    var iosSDKFile = location +
        '/ios/MobileRTC.xcframework/ios-arm64/MobileRTC.framework/MobileRTC';
    bool exists = await File(iosSDKFile).exists();

    if (!exists) {
      await downloadFile(
          Uri.parse(
              'https://www.dropbox.com/scl/fi/l4bxlhv6dqdto2koe2b8v/MobileRTC?rlkey=m0zep7hg9d1tn1twuwg7sho47&st=es941q33&dl=1'),
          iosSDKFile);
    }

    var iosSimulateSDKFile = location +
        '/ios/MobileRTC.xcframework/ios-arm64_x86_64-simulator/MobileRTC.framework/MobileRTC';
    exists = await File(iosSimulateSDKFile).exists();

    if (!exists) {
      await downloadFile(
          Uri.parse(
              'https://www.dropbox.com/scl/fi/r4nquy2qcue90rp2932pc/MobileRTC?rlkey=ujho0s6ezz55qw6xn1d9cne25&st=noawmmf9&dl=1'),
          iosSimulateSDKFile);
    }
  }

/*   var androidCommonLibFile = location + '/android/libs/commonlib.aar';
  bool exists = await File(androidCommonLibFile).exists();
  if (!exists) {
    await downloadFile(
        Uri.parse(
            'https://www.dropbox.com/scl/fi/zfr0dgi4i6d0l7mc98hnb/commonlib.aar?rlkey=t56nralbn31kkl8loudfvyu9h&dl=1'),
        androidCommonLibFile);
  } */
  var androidRTCLibFile = location + '/android/libs/mobilertc.aar';
  bool exists = await File(androidRTCLibFile).exists();
  if (!exists) {
    await downloadFile(
        Uri.parse(
            'https://www.dropbox.com/scl/fi/ez0x23u7ukqg40u48rm5u/mobilertc.aar?rlkey=qt2wts0v98dn08xv02ho38pnv&st=777mjsmg&dl=1'),
        androidRTCLibFile);
  }
}

Future<void> downloadFile(Uri uri, String savePath) async {
  print('Download ${uri.toString()} to $savePath');
  File destinationFile = await File(savePath).create(recursive: true);
  // var dio = Dio();
  // dio.options.connectTimeout = 1000000;
  // dio.options.receiveTimeout = 1000000;
  // dio.options.sendTimeout = 1000000;
  // await dio.downloadUri(uri, savePath);
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();
  await response.pipe(destinationFile.openWrite());
}
