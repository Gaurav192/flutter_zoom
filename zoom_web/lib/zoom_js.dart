@JS()
library zoom;

import 'package:js/js.dart';

@JS()
@anonymous // needed along with factory constructor
class InitParams {
  external factory InitParams(
      {leaveUrl,
      showMeetingHeader,
      disableInvite,
      disableCallOut,
      disableRecord,
      disableJoinAudio,
      audioPanelAlwaysOpen,
      showPureSharingContent,
      isSupportAV,
      isSupportChat,
      isSupportQA,
      isSupportCC,
      isSupportPolling,
      isSupportBreakout,
      screenShare,
      // rwcBackup,
      videoDrag,
      sharingMode,
      videoHeader,
      isLockBottom,
      isSupportNonverbal,
      isShowJoiningErrorDialog,
      disablePreview,
      disableCORP,
      inviteUrlFormat,
      disableVoIP,
      disableReport,
      meetingInfo,
      success,
      error});
  external String get leaveUrl;
}

@JS()
@anonymous // needed along with factory constructor
class JoinParams {
  external factory JoinParams(
      {meetingNumber, userName, signature, sdkKey, passWord, success, error});
}

@JS()
@anonymous // needed along with factory constructor
class SignatureParams {
  external factory SignatureParams({meetingNumber, sdkKey, apiSecret, role});
}

@JS()
@anonymous
class MeetingStatus {
  external factory MeetingStatus({int meetingStatus});
  external int get meetingStatus;
}

@JS()
class ZoomMtg {
  external static void setZoomJSLib(String path, String dir);
  external static final i18n;
  external static void preLoadWasm();
  external static void prepareWebSDK();
  external static void init(InitParams initParams);
  external static void join(JoinParams joinParams);
  external static String generateSignature(SignatureParams signatureParams);
  external static dynamic checkFeatureRequirements();
  external static void inMeetingServiceListener(
      String event, Function(MeetingStatus) callback);
}
