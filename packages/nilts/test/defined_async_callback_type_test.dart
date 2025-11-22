import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_async_callback_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedAsyncCallbackType', () {
    late DefinedAsyncCallbackTypeTest testInstance;

    setUp(() {
      testInstance = DefinedAsyncCallbackTypeTest()..setUp();
    });

    test('Future<void> Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<void> Function() callback) {}
''',
        [testInstance.lint(9, 23)],
      );
    });

    test('Future<void> Function()? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<void> Function()? callback) {}
''',
        [testInstance.lint(9, 24)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef AsyncCallback = Future<void> Function();

void foo(AsyncCallback callback) {}
''');
    });

    test('Future<void> Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function(int) callback) {}
''');
    });

    test('Future<int> Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<int> Function() callback) {}
''');
    });

    test('void Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function() callback) {}
''');
    });
  });
}

class DefinedAsyncCallbackTypeTest extends AnalysisRuleTest {
  @override
  void setUp() {
    // The rule must be set before calling super.setUp()
    rule = DefinedAsyncCallbackType();

    super.setUp();
  }
}
