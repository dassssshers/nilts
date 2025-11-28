import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/unstable_enum_name.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UnstableEnumName', () {
    late UnstableEnumNameTest testInstance;

    setUp(() {
      testInstance = UnstableEnumNameTest()..setUp();
    });

    test('using enum.name should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
enum Color { red, green, blue }

void printColorValue(Color color) {
  print(color.name);
}
''',
        [testInstance.lint(77, 10)],
      );
    });

    test(
      'using enum.name in string interpolation should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          r'''
enum Color { red, green, blue }

void printColorValue(Color color) {
  print('Color: ${color.name}');
}
''',
          [testInstance.lint(87, 10)],
        );
      },
    );

    test(
      'using enum.name in variable assignment should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          '''
enum Color { red, green, blue }

void printColorValue(Color color) {
  final name = color.name;
}
''',
          [testInstance.lint(84, 10)],
        );
      },
    );

    test('using custom getter should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
enum Color {
  red,
  green,
  blue,
  ;

  String get id => switch (this) {
    red => 'red',
    green => 'green',
    blue => 'blue',
  };
}

void printColorValue(Color color) {
  print(color.id);
}
''');
    });

    test('using non-enum property should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
class MyClass {
  String get name => 'test';
}

void foo(MyClass obj) {
  print(obj.name);
}
''');
    });

    test(
      'accessing different enum properties should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
enum Color { red, green, blue }

void foo(Color color) {
  print(color.index);
}
''');
      },
    );
  });
}

class UnstableEnumNameTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnstableEnumName.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UnstableEnumName());
    super.setUp();
  }
}
