import 'package:flutter_test/flutter_test.dart';

import 'package:network_flutter/network_flutter.dart';

void main() {
  test('Setup Request', () {
    final req = Request();
    expect(() => req.setup('https://demo.sugar.io/api'), returnsNormally);
  });
}
