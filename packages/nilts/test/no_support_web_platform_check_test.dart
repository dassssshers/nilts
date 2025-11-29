import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/no_support_web_platform_check.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('NoSupportWebPlatformCheck', () {
    late NoSupportWebPlatformCheckTest testInstance;

    setUp(() {
      testInstance = NoSupportWebPlatformCheckTest()..setUp();
    });

    test('Platform.isAndroid should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isAndroid = Platform.isAndroid;
''',
        [testInstance.lint(37, 18)],
      );
    });

    test('Platform.isIOS should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isIOS = Platform.isIOS;
''',
        [testInstance.lint(33, 14)],
      );
    });

    test('Platform.isMacOS should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isMacOS = Platform.isMacOS;
''',
        [testInstance.lint(35, 16)],
      );
    });

    test('Platform.isLinux should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isLinux = Platform.isLinux;
''',
        [testInstance.lint(35, 16)],
      );
    });

    test('Platform.isWindows should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isWindows = Platform.isWindows;
''',
        [testInstance.lint(37, 18)],
      );
    });

    test('Platform.isFuchsia should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'dart:io';

final isFuchsia = Platform.isFuchsia;
''',
        [testInstance.lint(37, 18)],
      );
    });

    test('other Platform properties should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'dart:io';

final numberOfProcessors = Platform.numberOfProcessors;
''');
    });

    test('custom Platform class should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
class Platform {
  static bool get isAndroid => false;
}

final isAndroid = Platform.isAndroid;
''');
    });
  });
}

class NoSupportWebPlatformCheckTest extends AnalysisRuleTest {
  @override
  String get analysisRule => NoSupportWebPlatformCheck.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(NoSupportWebPlatformCheck());
    super.setUp();

    // Extend the mock SDK's dart:io with Platform class
    final ioFile = getFile('/sdk/lib/io/io.dart');
    var ioContent = ioFile.readAsStringSync();

    const platformClass = '''

class Platform {
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isWindows => false;
  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isFuchsia => false;
  static int get numberOfProcessors => 1;
}
''';

    ioContent += platformClass;
    ioFile.writeAsStringSync(ioContent);
  }
}
