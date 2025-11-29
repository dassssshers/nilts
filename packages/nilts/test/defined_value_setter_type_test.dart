import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_value_setter_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedValueSetterType', () {
    late DefinedValueSetterTypeTest testInstance;

    setUp(() {
      testInstance = DefinedValueSetterTypeTest()..setUp();
    });

    test('void Function(int) should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(void Function(int) callback) {}
''',
        [testInstance.lint(9, 18)],
      );
    });

    test('void Function(String)? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(void Function(String)? callback) {}
''',
        [testInstance.lint(9, 22)],
      );
    });

    test('void Function(int?) should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(void Function(int?) callback) {}
''',
        [testInstance.lint(9, 19)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef ValueSetter<T> = void Function(T);

void foo(ValueSetter<int> callback) {}
''');
    });

    test('void Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function() callback) {}
''');
    });

    test('void Function(int, int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function(int, int) callback) {}
''');
    });

    test('int Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int Function(int) callback) {}
''');
    });

    test('void Function({int value}) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function({int value}) callback) {}
''');
    });

    test('void Function([int value]) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function([int value]) callback) {}
''');
    });
  });
}

class DefinedValueSetterTypeTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DefinedValueSetterType.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DefinedValueSetterType());
    super.setUp();
  }
}
