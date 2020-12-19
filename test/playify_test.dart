import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playify/playify.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.kaya.playify/playify');
  final List<MethodCall> log = <MethodCall>[];

  Playify playify = Playify();

  List<String> songIDs;
  String songID;
  bool startPlaying = true;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == "setQueue") {
        songID = methodCall.arguments["startID"];
        startPlaying = methodCall.arguments["startPlaying"];
        songIDs = List<String>.from(methodCall.arguments["songIDs"]);
      }
    });
  });

  tearDown(() {
    log.clear();
    channel.setMockMethodCallHandler(null);
  });

  group("setQueue", () {
    test('call setQueue correctly', () async {
      List<String> ids = ["s1", "s2"];
      await playify.setQueue(songIDs: ids);
      expect(log, <Matcher>[
        isMethodCall(
          'setQueue',
          arguments: <String, dynamic>{
            "songIDs": ids,
            "startPlaying": true,
            "startID": null
          },
        ),
      ]);
    });

    test('call setQueue incorrectly', () async {
      List<String> ids = ["s1", "s2"];
      String id = "s1";
      await playify.setQueue(songIDs: ids, startID: id);
      expect(log, <Matcher>[
        isNot(
          isMethodCall(
            'setQueue',
            arguments: <String, dynamic>{
              "songIDs": ids,
              "startPlaying": true,
              "startID": null
            },
          ),
        ),
      ]);
      log.clear();
    });

    test('songIDs should contain startID', () async {
      List<String> ids = ["s1", "s2"];
      String id = "s2";
      expect(
          () => playify.setQueue(songIDs: ids, startID: id), returnsNormally);
      log.clear();
      debugDefaultTargetPlatformOverride = null; // <-- this is required
    });
  });

  test('songIDs should throw error when it does not contain startID', () async {
    List<String> ids = ["s1", "s2"];
    String id = "s3";
    expect(() => playify.setQueue(songIDs: ids, startID: id), throwsException);
    log.clear();
  });
}
