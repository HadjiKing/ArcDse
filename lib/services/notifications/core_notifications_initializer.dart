import 'dart:io';

import 'package:arcdse/firebase_options.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/login.dart';
import 'package:arcdse/services/notifications/core_firebase_messaging.dart';
import 'package:arcdse/services/notifications/core_local_notification.dart';
import 'package:arcdse/services/notifications/push_deferring.dart';
import 'package:arcdse/services/notifications/push_relay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:arcdse/utils/js/js_bridge.dart';

class Messaging {
  static FirebaseMessagingService? firebase;
  static LocalNotificationsService? local;
  static Future<void> initializeReceiving() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebase = FirebaseMessagingService.instance();
      await firebase!.init();
      local = LocalNotificationsService.instance();
      await local!.init();
    }
  }

  static Future<void> identifyDevice() async {
    // initialize deferred push
    deferredPush.init(login.url);

    // ensure clinic key.. which is a key needed to communicate with the relay server
    final relayKey = await PushRelay.ensureKey();

    if (kIsWeb) {
      // check(/fcm/fcm.js)
      // communication to javascript through js bridge
      // by setting global variables
      // once those global variables are set
      // the javascript code will get the token
      // and use it to identify itself to the relay server
      JSBridge.setGlobalVariable("clinicKey", relayKey);
      JSBridge.setGlobalVariable("clinicServer", login.url);
      JSBridge.setGlobalVariable("accountId", login.currentAccountID);
      JSBridge.setGlobalVariable("lang", locale.s.$code);
      JSBridge.setGlobalVariable("shouldShowPrompt", "yes");
    } else {
      // this is for android and ios
      // this identifies this device to the relay server
      if (firebase != null &&
          firebase!.authStatus == AuthorizationStatus.authorized) {
        await PushRelay.putDevice();
      }
    }

    // no need for windows
    // since we're not supporting it yet with notifications
  }
}
