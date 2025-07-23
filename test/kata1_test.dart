import 'package:test/test.dart';

import '../bin/kata1.dart';

void main() {
  group('Kata1 Argument Parser Tests', () {
    test('returns 0 against an empty string', () {
      expect(add(""), 0);
    });
  });
}
