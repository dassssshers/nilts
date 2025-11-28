import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts_flutter_hooks/src/lints/unnecessary_hook_widget.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UnnecessaryHookWidget', () {
    late UnnecessaryHookWidgetTest testInstance;

    setUp(() {
      testInstance = UnnecessaryHookWidgetTest()..setUp();
    });

    test('HookWidget without hooks should trigger lint', () async {
      await testInstance.assertDiagnostics(
        '''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class FailedNoHooks extends HookWidget {
  const FailedNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}
''',
        [testInstance.lint(126, 10)],
      );
    });

    test(
      'HookWidget with mixin but without hooks should trigger lint',
      () async {
        await testInstance.assertDiagnostics(
          '''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class FailedWithWidgetNoHooks extends HookWidget
    with WidgetsBindingObserver {
  const FailedWithWidgetNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}
''',
          [testInstance.lint(136, 10)],
        );
      },
    );

    test(
      'HookWidget with useRef and useFocusNode should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UseHooks extends HookWidget {
  const UseHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useRef(0);
    final _ = useFocusNode();
    return const Text('Hello World!');
  }
}
''');
      },
    );

    test(
      'HookWidget with useTextEditingController should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UseHooks2 extends HookWidget {
  const UseHooks2({super.key});

  @override
  Widget build(BuildContext context) {
    useTextEditingController(text: '0');
    return const Text('Hello World!');
  }
}
''');
      },
    );

    test(
      'HookWidget with useTextEditingController.call() should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UseHooks3 extends HookWidget {
  const UseHooks3({super.key});

  @override
  Widget build(BuildContext context) {
    useTextEditingController.call(text: '0');
    return const Text('Hello World!');
  }
}
''');
      },
    );

    test('HookWidget with mixin and hooks should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class WithWidgetUseHooks extends HookWidget with WidgetsBindingObserver {
  const WithWidgetUseHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useRef(0);
    final _ = useFocusNode();
    return const Text('Hello World!');
  }
}
''');
    });

    test('StatelessWidget without hooks should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';

final class NoHooks extends StatelessWidget {
  const NoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}
''');
    });

    test('StatelessWidget with mixin should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';

final class WithWidgetNoHooks extends StatelessWidget
    with WidgetsBindingObserver {
  const WithWidgetNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}
''');
    });

    test('HookWidget with custom hooks should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UseCustomHooks extends HookWidget {
  const UseCustomHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useCustom();
    useInternalCustom();
    final _ = useCustom();
    return const Text('Hello World!');
  }

  void useInternalCustom() {}
}

UseCustomHook useCustom() {
  return UseCustomHook();
}

final class UseCustomHook {
  UseCustomHook();
}
''');
    });

    test(
      'HookWidget with custom private hooks should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class UseCustomPrivateHooks extends HookWidget {
  const UseCustomPrivateHooks({super.key});

  @override
  Widget build(BuildContext context) {
    _useCustomPrivate();
    _useInternalCustomPrivate();
    final _ = _useCustomPrivate();
    return const Text('Hello World!');
  }

  void _useInternalCustomPrivate() {}
}

UseCustomHook _useCustomPrivate() {
  return UseCustomHook();
}

final class UseCustomHook {
  UseCustomHook();
}
''');
      },
    );
  });
}

class UnnecessaryHookWidgetTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnnecessaryHookWidget.ruleName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UnnecessaryHookWidget());
    super.setUp();

    // Create a mock flutter package
    // Based on analyzer_testing's mock Flutter package structure
    newFile('/flutter/lib/material.dart', '''
export 'widgets.dart';
export 'src/material/text.dart';
''');

    newFile('/flutter/lib/widgets.dart', '''
export 'src/widgets/framework.dart';
''');

    newFile('/flutter/lib/src/widgets/framework.dart', '''
class Widget {
  final Key? key;
  const Widget({this.key});
  bool get mounted => true;
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({Key? key}) : super(key: key);
  Widget build(BuildContext context) => throw UnimplementedError();
}

class BuildContext {}

class Key {}

mixin WidgetsBindingObserver {}
''');

    newFile('/flutter/lib/src/material/text.dart', '''
import '../../widgets.dart';

class Text extends StatelessWidget {
  final String data;
  const Text(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
''');

    // Create a mock flutter_hooks package
    newFile('/flutter_hooks/lib/flutter_hooks.dart', '''
import 'package:flutter/widgets.dart';

abstract class HookWidget extends StatelessWidget {
  const HookWidget({Key? key}) : super(key: key);
}

Ref<T> useRef<T>(T initialValue) => throw UnimplementedError();

FocusNode useFocusNode() => throw UnimplementedError();

TextEditingController useTextEditingController({String? text}) =>
    throw UnimplementedError();

class FocusNode {}

class TextEditingController {}

class Ref<T> {}
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()
        ..add(name: 'flutter', rootPath: '/flutter')
        ..add(name: 'flutter_hooks', rootPath: '/flutter_hooks'),
    );
  }
}
