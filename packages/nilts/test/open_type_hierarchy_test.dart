import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/open_type_hierarchy.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('OpenTypeHierarchy', () {
    late OpenTypeHierarchyTest testInstance;

    setUp(() {
      testInstance = OpenTypeHierarchyTest()..setUp();
    });

    test('class without modifier should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
class MyClass {}
''',
        [testInstance.lint(0, 16)],
      );
    });

    test('final class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
final class MyClass {}
''');
    });

    test('sealed class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
sealed class MyClass {}
''');
    });

    test('base class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
base class MyClass {}
''');
    });

    test('abstract class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
abstract class MyClass {}
''');
    });

    test('interface class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
interface class MyClass {}
''');
    });

    test('mixin class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
mixin class MyClass {}
''');
    });
  });
}

class OpenTypeHierarchyTest extends AnalysisRuleTest {
  @override
  String get analysisRule => OpenTypeHierarchy.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(OpenTypeHierarchy());
    super.setUp();
  }
}
