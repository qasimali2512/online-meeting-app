import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:zoom/resources/auth-method.dart';
import 'package:zoom/resources/firestore_methods.dart';

class JitsiMeetMethod {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  Future<void> createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      Map<String, Object> featureFlags = {
        "welcomepage.enabled": false,
        "resolution": 360,
        "meeting-security.disabled": true,
        "security.disabled": true,
        "lobby-mode.enabled": false,
        "prejoinpage.enabled": false,
        "googleApi.disabled": true,
        "facebookApi.disabled": true,
      };

      final user = _authMethods.user;
      final String name = username.isNotEmpty
          ? username
          : (user?.displayName?.isNotEmpty == true ? user!.displayName! : "Guest");
      final String email = user?.email ?? "";
      final String photoUrl = user?.photoURL ?? "";

      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        serverUrl: "https://meet.jit.si",
        userDisplayName: name,
        userEmail: email,
        userAvatarUrl: photoUrl,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        featureFlags: featureFlags,
      );

      _firestoreMethods.addToMeetingHistory(roomName);

      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onConferenceWillJoin: (url) => debugPrint("onConferenceWillJoin: $url"),
          onConferenceJoined: (url) => debugPrint("onConferenceJoined: $url"),
          onConferenceTerminated: (url, error) =>
              debugPrint("onConferenceTerminated: $url, error: $error"),
        ),
      );
    } catch (error) {
      debugPrint("Error while creating meeting: $error");
    }
  }
}