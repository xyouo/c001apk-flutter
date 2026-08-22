import 'package:c001apk_flutter/logic/network/interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestApiInterceptor extends ApiInterceptor {
  _TestApiInterceptor({required super.tokenFactory});

  @override
  String get xAppDevice => 'test-device';
}

void main() {
  test('generates a fresh app token for every access', () {
    var calls = 0;
    final interceptor = _TestApiInterceptor(
      tokenFactory: (deviceCode) => '$deviceCode-token-${++calls}',
    );

    expect(interceptor.token, 'test-device-token-1');
    expect(interceptor.token, 'test-device-token-2');
    expect(calls, 2);
  });
}
