/// @docImport 'package:flutter/widgets.dart';
/// @docImport 'package:flutter_hooks/flutter_hooks.dart';
library;

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts_core/nilts_core.dart';
import 'package:nilts_flutter_hooks/src/fix_kind_priority.dart';

const _hookWidgetName = 'HookWidget';
const _hookNameRegex = r'^_?use[A-Z].*$';

const _statelessWidgetName = 'StatelessWidget';

const _description =
    'Consider using StatelessWidget instead of HookWidget '
    'when no hooks are used within the widget.';

/// A class for `unnecessary_hook_widget` rule.
///
/// This rule checks if [HookWidget] is used without any hooks.
/// If no hooks are found, it suggests replacing it with [StatelessWidget].
///
/// - Target SDK     : Any versions nilts_flutter_hooks supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **Prefer** using `StatelessWidget` instead of `HookWidget` when no hooks
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
class UnnecessaryHookWidget extends AnalysisRule {
  /// Create a new instance of [UnnecessaryHookWidget].
  UnnecessaryHookWidget()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'unnecessary_hook_widget';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Replace with $_statelessWidgetName',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addClassDeclaration(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final superclass = node.extendsClause?.superclass;
    if (superclass == null) return;

    final library = superclass.element?.library;
    if (library == null) return;
    if (!library.isFlutterHooks) return;

    if (superclass.name.lexeme != _hookWidgetName) return;

    var hasHooks = false;
    node.visitChildren(
      _HookDetectorVisitor(() {
        hasHooks = true;
      }),
    );

    if (!hasHooks) {
      rule.reportAtNode(superclass);
    }
  }
}

class _HookDetectorVisitor extends RecursiveAstVisitor<void> {
  const _HookDetectorVisitor(this.onHookFound);

  final void Function() onHookFound;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (RegExp(_hookNameRegex).hasMatch(node.methodName.name)) {
      onHookFound();
    }
    // for hooks like `useTextEditingController.call()`
    final target = node.realTarget;
    if (target != null && target is SimpleIdentifier) {
      if (RegExp(_hookNameRegex).hasMatch(target.name)) {
        onHookFound();
      }
    }
    super.visitMethodInvocation(node);
  }

  // for hooks like `useTextEditingController()`
  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    final function = node.function;
    if (function is SimpleIdentifier) {
      if (RegExp(_hookNameRegex).hasMatch(function.name)) {
        onHookFound();
      }
    }
    super.visitFunctionExpressionInvocation(node);
  }
}

/// A class for fixing `unnecessary_hook_widget` rule.
///
/// This fix replaces `HookWidget` with `StatelessWidget`.
class ReplaceWithStatelessWidget extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithStatelessWidget].
  ReplaceWithStatelessWidget({required super.context});

  static const _fixKind = FixKind(
    'nilts_flutter_hooks.fix.replaceWithStatelessWidget',
    FixKindPriority.replaceWithStatelessWidget,
    'Replace With $_statelessWidgetName',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final classDeclaration = node.thisOrAncestorOfType<ClassDeclaration>();
    if (classDeclaration == null) return;

    final superclass = classDeclaration.extendsClause?.superclass;
    if (superclass == null) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(superclass.offset, superclass.length),
        _statelessWidgetName,
      );
    });
  }
}
