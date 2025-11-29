import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/flaky_tests_with_set_up_all.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('FlakyTestsWithSetUpAll', () {
    late FlakyTestsWithSetUpAllTest testInstance;

    setUp(() {
      testInstance = FlakyTestsWithSetUpAllTest()..setUp();
    });

    test('using setUpAll from flutter_test should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {});
}
''',
        [testInstance.lint(66, 8)],
      );
    });

    test('using setUp should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});
}
''');
    });

    test('using tearDownAll should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDownAll(() {});
}
''');
    });
  });
}

class FlakyTestsWithSetUpAllTest extends AnalysisRuleTest {
  @override
  String get analysisRule => FlakyTestsWithSetUpAll.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(FlakyTestsWithSetUpAll());
    super.setUp();

    // Create mock flutter_test package
    newFile('/flutter_test/lib/flutter_test.dart', '''
void setUpAll(dynamic Function() body) {}
void setUp(dynamic Function() body) {}
void tearDownAll(dynamic Function() body) {}
void test(String description, dynamic Function() body) {}
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()
        ..add(name: 'flutter_test', rootPath: '/flutter_test'),
    );
  }
}
