@JS()
library zoom;

import 'dart:js_interop';

@JS()
@anonymous
@staticInterop // needed along with factory constructor
class InitParams {
  external factory InitParams(
      {JSString? leaveUrl,
      JSBoolean? showMeetingHeader,
      JSBoolean? disableInvite,
      JSBoolean? disableCallOut,
      JSBoolean? disableRecord,
      JSBoolean? disableJoinAudio,
      JSBoolean? audioPanelAlwaysOpen,
      JSBoolean? showPureSharingContent,
      JSBoolean? isSupportAV,
      JSBoolean? isSupportChat,
      JSBoolean? isSupportQA,
      JSBoolean? isSupportCC,
      JSBoolean? isSupportPolling,
      JSBoolean? isSupportBreakout,
      JSBoolean? screenShare,
      // rwcBackup,
      JSBoolean? videoDrag,
      JSString? sharingMode,
      JSBoolean? videoHeader,
      JSBoolean? isLockBottom,
      JSBoolean? isSupportNonverbal,
      JSBoolean? isShowJoiningErrorDialog,
      JSBoolean? disablePreview,
      JSBoolean? disableCORP,
      JSString? inviteUrlFormat,
      JSBoolean? disableVoIP,
      JSBoolean? disableReport,
      JSArray<JSString>? meetingInfo,
      JSFunction? success,
      JSFunction? error});
  external static String get leaveUrl;
}

@JS()
@anonymous
@staticInterop // needed along with factory constructor
class JoinParams {
  external factory JoinParams(
      {JSAny meetingNumber,
      JSString userName,
      JSString signature,
      JSString? sdkKey,
      JSString? passWord,
      JSFunction? success,
      JSFunction? error});
}

@JS()
@anonymous
@staticInterop // needed along with factory constructor
class SignatureParams {
  external factory SignatureParams(
      {JSString meetingNumber,
      JSString sdkKey,
      JSString apiSecret,
      JSString role});
}

@JS()
@anonymous
extension type MeetingStatus._(JSObject _) implements JSObject {
  external factory MeetingStatus({int meetingStatus});
  int get meetingStatus => meetingStatus;
}

@JS()
@anonymous
extension type ZoomMtgLang._(JSObject _) implements JSObject {
  external JSPromise<JSAny> load(JSString lang);
}

@JS()
@staticInterop
class ZoomMtg {
  external static void setZoomJSLib(JSString path, JSString dir);
  external static ZoomMtgLang i18n;
  external static void preLoadWasm();
  external static void prepareWebSDK();
  external static void init(InitParams initParams);
  external static void join(JoinParams joinParams);
  external static JSString generateSignature(SignatureParams signatureParams);
  external static JSAny checkFeatureRequirements();
  external static void inMeetingServiceListener(
      JSString event, JSFunction callback);
}
