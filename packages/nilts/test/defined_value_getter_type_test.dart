import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/defined_value_getter_type.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('DefinedValueGetterType', () {
    late DefinedValueGetterTypeTest testInstance;

    setUp(() {
      testInstance = DefinedValueGetterTypeTest()..setUp();
    });

    test('int Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(int Function() callback) {}
''',
        [testInstance.lint(9, 14)],
      );
    });

    test('String Function()? should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(String Function()? callback) {}
''',
        [testInstance.lint(9, 18)],
      );
    });

    test('int? Function() should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
void foo(int? Function() callback) {}
''',
        [testInstance.lint(9, 15)],
      );
    });

    test('typedef should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
typedef ValueGetter<T> = T Function();

void foo(ValueGetter<int> callback) {}
''');
    });

    test('void Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(void Function() callback) {}
''');
    });

    test('int Function(int) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(int Function(int) callback) {}
''');
    });

    test('Future<int> Function() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
void foo(Future<int> Function() callback) {}
''');
    });
  });
}

class DefinedValueGetterTypeTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DefinedValueGetterType.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DefinedValueGetterType());
    super.setUp();
  }
}
