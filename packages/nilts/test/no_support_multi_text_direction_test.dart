import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/no_support_multi_text_direction.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('NoSupportMultiTextDirection', () {
    late NoSupportMultiTextDirectionTest testInstance;

    setUp(() {
      testInstance = NoSupportMultiTextDirectionTest()..setUp();
    });

    // Alignment tests
    test('Alignment.bottomLeft should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

final alignment = Alignment.bottomLeft;
''',
        [testInstance.lint(58, 20)],
      );
    });

    test('Alignment.topRight should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

final alignment = Alignment.topRight;
''',
        [testInstance.lint(58, 18)],
      );
    });

    test('Alignment.center should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final alignment = Alignment.center;
''');
    });

    test('AlignmentDirectional.bottomStart should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final alignment = AlignmentDirectional.bottomStart;
''');
    });

    // EdgeInsets tests
    test('EdgeInsets.only with left should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

final padding = EdgeInsets.only(left: 8);
''',
        [testInstance.lint(56, 24)],
      );
    });

    test('EdgeInsets.only with right should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

final padding = EdgeInsets.only(right: 8);
''',
        [testInstance.lint(56, 25)],
      );
    });

    test('EdgeInsets.fromLTRB should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

final padding = EdgeInsets.fromLTRB(0, 0, 0, 0);
''',
        [testInstance.lint(56, 31)],
      );
    });

    test('EdgeInsets.only with top should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final padding = EdgeInsets.only(top: 8);
''');
    });

    test('EdgeInsets.all should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final padding = EdgeInsets.all(8);
''');
    });

    test('EdgeInsetsDirectional.only should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final padding = EdgeInsetsDirectional.only(start: 8);
''');
    });

    // Positioned tests
    test('Positioned with left should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Widget build() {
  return Positioned(
    left: 0,
    child: Container(),
  );
}
''',
        [testInstance.lint(66, 52)],
      );
    });

    test('Positioned with right should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Widget build() {
  return Positioned(
    right: 0,
    child: Container(),
  );
}
''',
        [testInstance.lint(66, 53)],
      );
    });

    test('Positioned with top only should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return Positioned(
    top: 0,
    child: Container(),
  );
}
''');
    });

    test('PositionedDirectional should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return PositionedDirectional(
    start: 0,
    child: Container(),
  );
}
''');
    });
  });
}

class NoSupportMultiTextDirectionTest extends AnalysisRuleTest {
  @override
  String get analysisRule => NoSupportMultiTextDirection.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(NoSupportMultiTextDirection());
    super.setUp();

    // Create a mock flutter package
    newFile('/flutter/lib/widgets.dart', '''
class Widget {
  const Widget();
}

class Alignment {
  const Alignment._();
  static const Alignment topLeft = Alignment._();
  static const Alignment topRight = Alignment._();
  static const Alignment centerLeft = Alignment._();
  static const Alignment centerRight = Alignment._();
  static const Alignment bottomLeft = Alignment._();
  static const Alignment bottomRight = Alignment._();
  static const Alignment center = Alignment._();
  static const Alignment topCenter = Alignment._();
  static const Alignment bottomCenter = Alignment._();
}

class AlignmentDirectional {
  const AlignmentDirectional._();
  static const AlignmentDirectional topStart = AlignmentDirectional._();
  static const AlignmentDirectional topEnd = AlignmentDirectional._();
  static const AlignmentDirectional centerStart = AlignmentDirectional._();
  static const AlignmentDirectional centerEnd = AlignmentDirectional._();
  static const AlignmentDirectional bottomStart = AlignmentDirectional._();
  static const AlignmentDirectional bottomEnd = AlignmentDirectional._();
}

class EdgeInsets {
  const EdgeInsets._();

  const factory EdgeInsets.fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) = EdgeInsets._;

  const factory EdgeInsets.only({
    double left,
    double top,
    double right,
    double bottom,
  }) = EdgeInsets._;

  const factory EdgeInsets.all(double value) = EdgeInsets._;
}

class EdgeInsetsDirectional {
  const EdgeInsetsDirectional._();

  const factory EdgeInsetsDirectional.only({
    double start,
    double top,
    double end,
    double bottom,
  }) = EdgeInsetsDirectional._;

  const factory EdgeInsetsDirectional.fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) = EdgeInsetsDirectional._;
}

class Positioned extends Widget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Widget child;

  const Positioned({
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.child,
  });

  const Positioned.fill({
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.child,
  });
}

class PositionedDirectional extends Widget {
  final double? start;
  final double? top;
  final double? end;
  final double? bottom;
  final Widget child;

  const PositionedDirectional({
    this.start,
    this.top,
    this.end,
    this.bottom,
    required this.child,
  });
}

class Container extends Widget {
  const Container();
}
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()..add(name: 'flutter', rootPath: '/flutter'),
    );
  }
}
