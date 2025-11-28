import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/fixed_text_scale_rich_text.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('FixedTextScaleRichText', () {
    late FixedTextScaleRichTextTest testInstance;

    setUp(() {
      testInstance = FixedTextScaleRichTextTest()..setUp();
    });

    test('RichText without textScaler should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Widget build() {
  return RichText(
    text: const TextSpan(text: 'Hello'),
  );
}
''',
        [testInstance.lint(66, 54)],
      );
    });

    test('RichText with textScaler should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return RichText(
    text: const TextSpan(text: 'Hello'),
    textScaler: TextScaler.noScaling,
  );
}
''');
    });

    test('RichText with textScaleFactor should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return RichText(
    text: const TextSpan(text: 'Hello'),
    textScaleFactor: 1.0,
  );
}
''');
    });

    test('non-RichText widget should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return Text('Hello');
}
''');
    });
  });
}

class FixedTextScaleRichTextTest extends AnalysisRuleTest {
  @override
  String get analysisRule => FixedTextScaleRichText.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(FixedTextScaleRichText());
    super.setUp();

    // Create a mock flutter package
    newFile('/flutter/lib/widgets.dart', '''
class Widget {
  const Widget();
}

class RichText extends Widget {
  final InlineSpan text;
  final TextScaler? textScaler;
  final double? textScaleFactor;

  const RichText({
    required this.text,
    this.textScaler,
    this.textScaleFactor,
  });
}

class Text extends Widget {
  final String data;
  const Text(this.data);
}

class TextSpan implements InlineSpan {
  final String? text;
  const TextSpan({this.text});
}

abstract class InlineSpan {}

class TextScaler {
  const TextScaler._();
  static const TextScaler noScaling = TextScaler._();
}
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()..add(name: 'flutter', rootPath: '/flutter'),
    );
  }
}
