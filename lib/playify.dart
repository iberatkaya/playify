import 'dart:async';

import 'package:flutter/services.dart';

class Playify {
  Player(){
    
  }
  static const MethodChannel _channel =
      const MethodChannel('com.kaya.playify/playify');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> play() async {
    try{
      final int result = await _channel.invokeMethod('play');
      print(result);
    } catch(e){
      print(e);
    }
  }
}
