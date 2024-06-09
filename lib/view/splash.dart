import 'dart:async';

import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/gen/assets.gen.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/network/status_code.dart';
import 'package:re_open_chat/network/user/types.dart';
import 'package:re_open_chat/network/user/user.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late Size screenSize;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var timerFinished = false;
  var initFinished = false;
  var jumping = false;
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    _startTimer();
    _startInit();
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Assets.imgs.background.image(fit: BoxFit.cover),
      const Center(child: CircularProgressIndicator()),
    ]));
  }

  void _startTimer() {
    timer = Timer(const Duration(seconds: 1), () {
      timerFinished = true;
      talker.debug('timerFinished');
      if (initFinished && !jumping) _leaveSplash();
    });
  }

  void _startInit() async {
    prefs = await SharedPreferences.getInstance();
    getDeviceID();
    initFinished = true;
    talker.debug('initFinished');
    if (timerFinished && !jumping) _leaveSplash();
  }

  void _leaveSplash() async {
    jumping = true;
    if (prefs.getBool('autoLogin') == true) {
      if (await _testAccount()) {
        globalBloc.add(AutoLoginSucceed(
          prefs.getString('phone')!,
          prefs.getString('password')!,
          prefs.getInt('id')!,
          prefs.getString('name') ?? '',
          prefs.getString('profile') ?? '',
        ));
        return;
      }
    }
    router.goNamed('hello');
  }

  Future<bool> _testAccount() async {
    final phone = prefs.getString('phone');
    final password = prefs.getString('password');
    if (phone == null || password == null) {
      return false;
    }
    try {
      final result = await userApi.login(LoginData(
          phoneNumber: phone, password: password, deviceId: deviceId));
      if (result.statusCode != StatusCode.success.value) {
        clearSharedPreference();
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}

void clearSharedPreference() async {
  prefs.setString('phone', '');
  prefs.setString('password', '');
  prefs.setInt('id', 0);
  prefs.setString('name', '');
  prefs.setString('profile', '');
}
