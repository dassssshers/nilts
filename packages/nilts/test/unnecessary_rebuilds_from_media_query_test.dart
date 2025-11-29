import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/unnecessary_rebuilds_from_media_query.dart';
import 'package:nilts_core/nilts_core.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UnnecessaryRebuildsFromMediaQuery', () {
    late UnnecessaryRebuildsFromMediaQueryTest testInstance;

    setUp(() {
      testInstance = UnnecessaryRebuildsFromMediaQueryTest()..setUp();
    });

    test('MediaQuery.of(context).size should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}
''',
        [testInstance.lint(97, 2)],
      );
    });

    test('MediaQuery.of(context).padding should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

EdgeInsets getPadding(BuildContext context) {
  return MediaQuery.of(context).padding;
}
''',
        [testInstance.lint(106, 2)],
      );
    });

    test('MediaQuery.maybeOf(context).size should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Size? getSize(BuildContext context) {
  return MediaQuery.maybeOf(context)?.size;
}
''',
        [testInstance.lint(98, 7)],
      );
    });

    test('MediaQuery.sizeOf(context) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Size getSize(BuildContext context) {
  return MediaQuery.sizeOf(context);
}
''');
    });

    test('MediaQuery.paddingOf(context) should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

EdgeInsets getPadding(BuildContext context) {
  return MediaQuery.paddingOf(context);
}
''');
    });

    test('MediaQuery.of(context) without property access '
        'should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

MediaQueryData getData(BuildContext context) {
  return MediaQuery.of(context);
}
''');
    });

    test('non-MediaQuery method should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

void foo(BuildContext context) {
  Theme.of(context);
}

class Theme {
  static ThemeData of(BuildContext context) => ThemeData();
}

class ThemeData {}
''');
    });
  });
}

class UnnecessaryRebuildsFromMediaQueryTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnnecessaryRebuildsFromMediaQuery.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(
      UnnecessaryRebuildsFromMediaQuery(
        const DartVersion(major: 3, minor: 2, patch: 0),
      ),
    );
    super.setUp();

    // Create a mock flutter package
    newFile('/flutter/lib/widgets.dart', '''
class BuildContext {}

class Size {
  final double width;
  final double height;
  const Size(this.width, this.height);
}

class EdgeInsets {
  const EdgeInsets._();
  static const EdgeInsets zero = EdgeInsets._();
}

class MediaQueryData {
  final Size size;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;
  final EdgeInsets viewPadding;
  final double devicePixelRatio;
  final double textScaleFactor;

  const MediaQueryData({
    this.size = const Size(0, 0),
    this.padding = EdgeInsets.zero,
    this.viewInsets = EdgeInsets.zero,
    this.viewPadding = EdgeInsets.zero,
    this.devicePixelRatio = 1.0,
    this.textScaleFactor = 1.0,
  });
}

class MediaQuery {
  static MediaQueryData of(BuildContext context) => const MediaQueryData();
  static MediaQueryData? maybeOf(BuildContext context) => const MediaQueryData();
  static Size sizeOf(BuildContext context) => const Size(0, 0);
  static EdgeInsets paddingOf(BuildContext context) => EdgeInsets.zero;
  static EdgeInsets viewInsetsOf(BuildContext context) => EdgeInsets.zero;
}
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()..add(name: 'flutter', rootPath: '/flutter'),
    );
  }
}
