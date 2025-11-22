import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_async_value_getter_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedAsyncValueGetterType', () {
    late DefinedAsyncValueGetterTypeTest testInstance;

    setUp(() {
      testInstance = DefinedAsyncValueGetterTypeTest()..setUp();
    });

    test('Future<int> Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<int> Function() callback) {}
''',
        [testInstance.lint(9, 22)],
      );
    });

    test('Future<String> Function()? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<String> Function()? callback) {}
''',
        [testInstance.lint(9, 26)],
      );
    });

    test('Future<int?> Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<int?> Function() callback) {}
''',
        [testInstance.lint(9, 23)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef AsyncValueGetter<T> = Future<T> Function();

void foo(AsyncValueGetter<int> callback) {}
''');
    });

    test('Future<void> Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function() callback) {}
''');
    });

    test('Future<int> Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<int> Function(int) callback) {}
''');
    });

    test('int Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int Function() callback) {}
''');
    });
  });
}

class DefinedAsyncValueGetterTypeTest extends AnalysisRuleTest {
  @override
  void setUp() {
    // The rule must be set before calling super.setUp()
    rule = DefinedAsyncValueGetterType();

    super.setUp();
  }
}
