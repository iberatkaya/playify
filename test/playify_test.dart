import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playify/playify.dart';

void main() {
  const MethodChannel channel = MethodChannel('playify');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Playify.platformVersion, '42');
  });
}
