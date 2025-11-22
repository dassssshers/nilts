import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_void_callback_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedVoidCallbackType', () {
    late DefinedVoidCallbackTypeTest testInstance;

    setUp(() {
      testInstance = DefinedVoidCallbackTypeTest()..setUp();
    });

    test('void Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(void Function() callback) {}
''',
        [testInstance.lint(9, 15)],
      );
    });

    test('void Function()? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(void Function()? callback) {}
''',
        [testInstance.lint(9, 16)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef VoidCallback = void Function();

void foo(VoidCallback callback) {}
''');
    });

    test('void Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function(int) callback) {}
''');
    });

    test('int Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int Function() callback) {}
''');
    });
  });
}

class DefinedVoidCallbackTypeTest extends AnalysisRuleTest {
  @override
  void setUp() {
    // The rule must be set before calling super.setUp()
    rule = DefinedVoidCallbackType();

    super.setUp();
  }
}
