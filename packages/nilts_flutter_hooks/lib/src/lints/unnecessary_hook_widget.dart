// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts_core/nilts_core.dart';
import 'package:nilts_flutter_hooks/src/change_priority.dart';

/// A class for `unnecessary_hook_widget` rule.
///
/// This rule checks if [HookWidget] is used without any hooks.
/// If no hooks are found, it suggests replacing it with [StatelessWidget].
///
/// - Target SDK     : Any versions nilts_flutter_hooks supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** using `StatelessWidget` instead of `HookWidget` when no hooks
/// are used within the widget.
///
/// **BAD:**
/// ```dart
/// class NoHooksWidget extends HookWidget {
///   const NoHooksWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) => const Text('Hello World!');
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// class NoHooksWidget extends StatelessWidget {
///   const NoHooksWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) => const Text('Hello World!');
/// }
/// ```
///
/// **Note: [HookWidget] usage is appropriate in the following cases:**
/// - When using hooks within the widget
/// - When extending [HookWidget] for a base widget class
/// - When mixing in hook functionality with other widgets
///
/// See also:
/// - [HookWidget class - flutter_hooks API](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/HookWidget-class.html)
/// - [StatelessWidget class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
class UnnecessaryHookWidget extends DartLintRule {
  /// Create a new instance of [UnnecessaryHookWidget].
  const UnnecessaryHookWidget()
      : super(
          code: const LintCode(
            name: 'unnecessary_hook_widget',
            problemMessage:
                'Consider using StatelessWidget instead of HookWidget '
                'when no hooks are used within the widget.',
            url: 'https://github.com/dassssshers/nilts#unnecessary_hook_widget',
          ),
        );

  @override
  void run(
    CustomLintResolver _,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final superclass = node.extendsClause?.superclass;
      final library = superclass?.element?.library;
      if (library == null) return;
      if (!library.checkPackage(packageName: 'flutter_hooks')) return;

      if (superclass == null || superclass.toString() != 'HookWidget') return;

      var hasHooks = false;
      node.visitChildren(
        _Visitor(() {
          hasHooks = true;
        }),
      );

      if (!hasHooks) {
        reporter.atNode(superclass, code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithStatelessWidget(),
      ];
}

class _Visitor extends RecursiveAstVisitor<void> {
  const _Visitor(this.onHookFound);

  final void Function() onHookFound;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name.startsWith('use')) {
      onHookFound();
    }
    super.visitMethodInvocation(node);
  }
}

class _ReplaceWithStatelessWidget extends DartFix {
  @override
  void run(
    CustomLintResolver _,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> __,
  ) {
    context.registry.addClassDeclaration((declaration) {
      final superclass = declaration.extendsClause?.superclass;
      if (superclass == null ||
          !analysisError.sourceRange.intersects(superclass.sourceRange)) {
        return;
      }

      final replacement = _getReplacementWidget(superclass.toString());
      if (replacement == null) return;

      reporter
          .createChangeBuilder(
        message: 'Replace With $replacement',
        priority: ChangePriority.replaceWithStatelessWidget,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(superclass.offset, superclass.length),
          replacement,
        );
      });
    });
  }

  String? _getReplacementWidget(String className) => switch (className) {
        'HookWidget' => 'StatelessWidget',
        _ => null,
      };
}
