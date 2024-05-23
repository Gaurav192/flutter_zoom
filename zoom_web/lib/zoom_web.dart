import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';
import 'package:zoom_platform_interface/zoom_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zoom_web/zoom_js.dart';

import 'js_interop.dart';
export 'package:zoom_platform_interface/zoom_platform_interface.dart'
    show ZoomOptions, ZoomMeetingOptions;

// _toDartSimpleObject(thing) {
//   var rt = thing.runtimeType.toString();
//   if (thing is JsArray) {
//     List res = new List();
//     JsArray a = thing as JsArray;
//     a.forEach((otherthing) {
//       res.add(_toDartSimpleObject(otherthing));
//     });
//     return res;
//   } else if (thing is JsObject) {
//     Map res = new Map();
//     JsObject o = thing as JsObject;
//     Iterable<String> k = context['Object'].callMethod('keys', [o]);
//     k.forEach((String k) {
//       res[k] = _toDartSimpleObject(o[k]);
//     });
//     return res;
//   } else {
//     return thing;
//   }
// }
class ZoomWeb extends ZoomPlatform {
  StreamController<dynamic>? streamController;
  static void registerWith(Registrar registrar) {
    ZoomPlatform.instance = ZoomWeb();
  }

  static const _zoomSdkVersion = '3.1.0';

  static String get _selectZoomSdkVersion {
    print(globalContext.hasProperty('zoomSdkVersion'.toJS));
    return globalContext.hasProperty('zoomSdkVersion'.toJS).toDart
        ? globalContext.getProperty('zoomSdkVersion'.toJS).dartify().toString()
        : _zoomSdkVersion;
  }

  @override
  Future<List> initZoom(ZoomOptions options) async {
    ZoomMtg.setZoomJSLib(
        'https://source.zoom.us/$_selectZoomSdkVersion/lib'.toJS, '/av'.toJS);
    final Completer<List> completer = Completer();
    var sus = ZoomMtg.checkFeatureRequirements();
    var susmap = convertToDart(sus);
    debugPrint(susmap.toString());
    ZoomMtg.i18n.load(options.language!.toJS);
    ZoomMtg.preLoadWasm();
    ZoomMtg.prepareWebSDK();
    ZoomMtg.init(InitParams(
        leaveUrl: options.leaveUrl.toJS,
        showMeetingHeader: options.showMeetingHeader?.toJS,
        disableInvite: options.disableInvite?.toJS,
        disableCallOut: options.disableCallOut?.toJS,
        disableRecord: options.disableRecord?.toJS,
        disableJoinAudio: options.disableJoinAudio?.toJS,
        audioPanelAlwaysOpen: options.audioPanelAlwaysOpen?.toJS,
        isSupportAV: options.isSupportAV?.toJS,
        isSupportChat: options.isSupportChat?.toJS,
        isSupportQA: options.isSupportQA?.toJS,
        isSupportCC: options.isSupportCC?.toJS,
        isSupportPolling: options.isSupportPolling?.toJS,
        isSupportBreakout: options.isSupportBreakout?.toJS,
        screenShare: options.screenShare?.toJS,
        // rwcBackup: options.rwcBackup,
        videoDrag: options.videoDrag?.toJS,
        sharingMode: options.sharingMode?.toJS,
        videoHeader: options.videoHeader?.toJS,
        isLockBottom: options.isLockBottom?.toJS,
        isSupportNonverbal: options.isSupportNonverbal?.toJS,
        isShowJoiningErrorDialog: options.isShowJoiningErrorDialog?.toJS,
        disablePreview: options.disablePreview?.toJS,
        disableCORP: options.disableCORP?.toJS,
        inviteUrlFormat: options.inviteUrlFormat?.toJS,
        disableVoIP: options.disableVOIP?.toJS,
        disableReport: options.disableReport?.toJS,
        meetingInfo: options.meetingInfo?.map((e) => e.toJS).toList().toJS,
        success: ((JSAny res) {
          completer.complete([0, 0]);
        }).toJS,
        error: ((JSAny res) {
          completer.complete([1, 0]);
        }).toJS));
    return completer.future;
  }

  @override
  Future<bool> startMeeting(ZoomMeetingOptions options) async {
    return false;
  }

  @override
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    final Completer<bool> completer = Completer();
    // final signature = ZoomMtg.generateSignature(SignatureParams(
    //     meetingNumber: options.meetingId,
    //     apiKey: options.jwtAPIKey!,
    //     apiSecret: "ApiKey",
    //     role: 0));
    ZoomMtg.join(JoinParams(
        meetingNumber: (options.meetingId.toJS),
        userName: (options.displayName ?? options.userId).toJS,
        signature: options.signature!.toJS,
        sdkKey: options.sdkKey!.toJS,
        passWord: options.meetingPassword.toJS,
        success: ((JSAny res) {
          if (!completer.isCompleted) completer.complete(true);
        }).toJS,
        error: ((JSAny res) {
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        }).toJS));
    return completer.future;
  }

  @override
  Future<List> meetingStatus(String meetingId) async {
    return ["a", "b"];
  }

  @override
  Stream<dynamic> onMeetingStatus() {
    // final Completer<bool> completer = Completer();
    streamController?.close();
    streamController = StreamController<dynamic>();
    ZoomMtg.inMeetingServiceListener(
        'onMeetingStatus'.toJS,
        ((MeetingStatus status) {
          //print(stringify(MeetingStatus status));
          var r = List<String>.filled(2, "");
          // 1(connecting), 2(connected), 3(disconnected), 4(reconnecting)
          switch (status.meetingStatus) {
            case 1:
              r[0] = "MEETING_STATUS_CONNECTING";
              break;
            case 2:
              r[0] = "MEETING_STATUS_INMEETING";
              break;
            case 3:
              r[0] = "MEETING_STATUS_DISCONNECTING";
              break;
            case 4:
              r[0] = "MEETING_STATUS_INMEETING";
              break;
            default:
              r[0] = status.meetingStatus.toString();
              break;
          }
          streamController!.add(r);
        }).toJS);
    return streamController!.stream;
  }
}
