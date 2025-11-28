import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/low_readability_numeric_literals.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('LowReadabilityNumericLiterals', () {
    late LowReadabilityNumericLiteralsTest testInstance;

    setUp(() {
      testInstance = LowReadabilityNumericLiteralsTest()..setUp();
    });

    test('5+ digit number without separator should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
const value = 12345;
''',
        [testInstance.lint(14, 5)],
      );
    });

    test('large number without separator should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
const value = 123456789;
''',
        [testInstance.lint(14, 9)],
      );
    });

    test(
      'negative large number without separator should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          '''
const value = -12345;
''',
          [testInstance.lint(15, 5)],
        );
      },
    );

    test('number with separator should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
const value = 123_456;
''');
    });

    test('4 digit number should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
const value = 1234;
''');
    });

    test('small number should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
const value = 100;
''');
    });
  });
}

class LowReadabilityNumericLiteralsTest extends AnalysisRuleTest {
  @override
  String get analysisRule => LowReadabilityNumericLiterals.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(LowReadabilityNumericLiterals());
    super.setUp();
  }
}
