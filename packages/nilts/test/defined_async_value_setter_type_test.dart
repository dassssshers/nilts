import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_async_value_setter_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedAsyncValueSetterType', () {
    late DefinedAsyncValueSetterTypeTest testInstance;

    setUp(() {
      testInstance = DefinedAsyncValueSetterTypeTest()..setUp();
    });

    test('Future<void> Function(int) should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<void> Function(int) callback) {}
''',
        [testInstance.lint(9, 26)],
      );
    });

    test('Future<void> Function(String)? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<void> Function(String)? callback) {}
''',
        [testInstance.lint(9, 30)],
      );
    });

    test('Future<void> Function(int?) should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(Future<void> Function(int?) callback) {}
''',
        [testInstance.lint(9, 27)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef AsyncValueSetter<T> = Future<void> Function(T);

void foo(AsyncValueSetter<int> callback) {}
''');
    });

    test('Future<void> Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function() callback) {}
''');
    });

    test('Future<void> Function(int, int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function(int, int) callback) {}
''');
    });

    test('Future<int> Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<int> Function(int) callback) {}
''');
    });

    test('void Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function(int) callback) {}
''');
    });

    test(
      'Future<void> Function({int value}) should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function({int value}) callback) {}
''');
      },
    );

    test(
      'Future<void> Function([int value]) should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
void foo(Future<void> Function([int value]) callback) {}
''');
      },
    );
  });
}

class DefinedAsyncValueSetterTypeTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DefinedAsyncValueSetterType.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DefinedAsyncValueSetterType());
    super.setUp();
  }
}
