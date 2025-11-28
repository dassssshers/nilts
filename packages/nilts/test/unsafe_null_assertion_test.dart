import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/unsafe_null_assertion.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UnsafeNullAssertion', () {
    late UnsafeNullAssertionTest testInstance;

    setUp(() {
      testInstance = UnsafeNullAssertionTest()..setUp();
    });

    test('null assertion should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(int? someValue) {
  final value = someValue!;
}
''',
        [testInstance.lint(52, 1)],
      );
    });

    test('null assertion in method call should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(int? someValue) {
  final value = someValue!.toString();
}
''',
        [testInstance.lint(52, 1)],
      );
    });

    test('null assertion in property access should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(List<int>? someValue) {
  final value = someValue!.length;
}
''',
        [testInstance.lint(58, 1)],
      );
    });

    test('normal code should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int someValue) {
  final value = someValue;
}
''');
    });

    test('if-null operator should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int? someValue, int defaultValue) {
  final value = someValue ?? defaultValue;
}
''');
    });

    test('null-aware operator should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int? someValue) {
  final value = someValue?.toString();
}
''');
    });

    test('pattern matching should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int? someValue) {
  if (someValue case final value?) {
    print(value);
  }
}
''');
    });
  });
}

class UnsafeNullAssertionTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnsafeNullAssertion.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UnsafeNullAssertion());
    super.setUp();
  }
}
