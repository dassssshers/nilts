import 'package:flutter_test/flutter_test.dart';

void main() {
  // ===========================================================================
  // nilts/flaky_tests_with_set_up_all
  // - Using setUpAll() which can cause flaky tests
  // ===========================================================================
  // ignore: nilts/flaky_tests_with_set_up_all
  setUpAll(() {
    // This setup runs once before all tests in this group
    // but can cause flaky tests due to shared state
  });

  test('sample test', () {
    expect(1 + 1, 2);
  });
}
