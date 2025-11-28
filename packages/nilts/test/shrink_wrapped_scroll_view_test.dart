import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts/src/lints/shrink_wrapped_scroll_view.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('ShrinkWrappedScrollView', () {
    late ShrinkWrappedScrollViewTest testInstance;

    setUp(() {
      testInstance = ShrinkWrappedScrollViewTest()..setUp();
    });

    test('ListView with shrinkWrap: true should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Widget build() {
  return ListView(
    shrinkWrap: true,
    children: const [],
  );
}
''',
        [testInstance.lint(66, 59)],
      );
    });

    test('GridView with shrinkWrap: true should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/widgets.dart';

Widget build() {
  return GridView.count(
    shrinkWrap: true,
    crossAxisCount: 2,
    children: const [],
  );
}
''',
        [testInstance.lint(66, 88)],
      );
    });

    test(
      'CustomScrollView with shrinkWrap: true should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          '''
import 'package:flutter/widgets.dart';

Widget build() {
  return CustomScrollView(
    shrinkWrap: true,
    slivers: const [],
  );
}
''',
          [testInstance.lint(66, 66)],
        );
      },
    );

    test('ListView without shrinkWrap should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return ListView(
    children: const [],
  );
}
''');
    });

    test('ListView with shrinkWrap: false should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return ListView(
    shrinkWrap: false,
    children: const [],
  );
}
''');
    });

    test('non-ScrollView widget should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget build() {
  return Container();
}
''');
    });
  });
}

class ShrinkWrappedScrollViewTest extends AnalysisRuleTest {
  @override
  String get analysisRule => ShrinkWrappedScrollView.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(ShrinkWrappedScrollView());
    super.setUp();

    // Create a mock flutter package
    newFile('/flutter/lib/widgets.dart', '''
class Widget {
  const Widget();
}

class ScrollView extends Widget {
  final bool shrinkWrap;
  const ScrollView({this.shrinkWrap = false});
}

class ListView extends ScrollView {
  final List<Widget> children;
  const ListView({
    super.shrinkWrap,
    this.children = const [],
  });
}

class GridView extends ScrollView {
  final int crossAxisCount;
  final List<Widget> children;

  const GridView.count({
    super.shrinkWrap,
    required this.crossAxisCount,
    this.children = const [],
  });
}

class CustomScrollView extends ScrollView {
  final List<Widget> slivers;
  const CustomScrollView({
    super.shrinkWrap,
    this.slivers = const [],
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
