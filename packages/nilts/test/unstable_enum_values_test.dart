import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/unstable_enum_values.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UnstableEnumValues', () {
    late UnstableEnumValuesTest testInstance;

    setUp(() {
      testInstance = UnstableEnumValuesTest()..setUp();
    });

    test('using Enum.values should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
enum Color { red, green, blue }

void printColors() {
  for (final color in Color.values) {
    print(color);
  }
}
''',
        [testInstance.lint(76, 12)],
      );
    });

    test(
      'using Enum.values in variable assignment should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          '''
enum Color { red, green, blue }

void printColors() {
  final colors = Color.values;
}
''',
          [testInstance.lint(71, 12)],
        );
      },
    );

    test('iterating Enum.values with forEach should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
enum Color { red, green, blue }

void printColors() {
  Color.values.forEach(print);
}
''',
        [testInstance.lint(56, 12)],
      );
    });

    test('using custom list should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
enum Color { red, green, blue }

void printColors() {
  final colors = [Color.red, Color.green, Color.blue];
  for (final color in colors) {
    print(color);
  }
}
''');
    });

    test('using explicit enum values should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
enum Color { red, green, blue }

void foo() {
  final red = Color.red;
  final green = Color.green;
  final blue = Color.blue;
}
''');
    });

    test('accessing non-enum class values should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
class MyClass {
  static const values = ['a', 'b', 'c'];
}

void foo() {
  print(MyClass.values);
}
''');
    });
  });
}

class UnstableEnumValuesTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnstableEnumValues.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UnstableEnumValues());
    super.setUp();
  }
}
