// ignore_for_file: comment_references to avoid unnecessary imports

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
import 'package:nilts/src/fix_kind_priority.dart';
import 'package:nilts_core/nilts_core.dart';

const _description =
    'Shrink wrapping the content of the scroll view is significantly more '
    'expensive than expanding to the maximum allowed size.';

const _scrollViewSubClasses = [
  'ListView',
  'GridView',
  'CustomScrollView',
];

/// A class for `shrink_wrapped_scroll_view` rule.
///
/// This rule checks if the content of the scroll view is shrink wrapped.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **Consider** removing `shrinkWrap` argument and update the Widget not to
/// shrink wrap.
/// Shrink wrapping the content of the scroll view is
/// significantly more expensive than expanding to the maximum allowed size
/// because the content can expand and contract during scrolling,
/// which means the size of the scroll view needs to be recomputed
/// whenever the scroll position changes.
///
/// You can avoid shrink wrap with 3 steps below
/// in case of your scroll view is nested.
///
/// 1. Replace the parent scroll view with [CustomScrollView].
/// 2. Replace the child scroll view with [SliverListView] or [SliverGridView].
/// 3. Set [SliverChildBuilderDelegate] to `delegate` argument of
/// [SliverListView] or [SliverGridView].
///
/// **BAD:**
/// ```dart
/// ListView(shrinkWrap: true)
/// ```
///
/// **GOOD:**
/// ```dart
/// ListView(shrinkWrap: false)
/// ```
///
/// See also:
///
/// - [shrinkWrap property - ScrollView class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/ScrollView/shrinkWrap.html)
/// - [ShrinkWrap vs Slivers | Decoding Flutter - YouTube](https://youtu.be/LUqDNnv_dh0)
class ShrinkWrappedScrollView extends AnalysisRule {
  /// Create a new instance of [ShrinkWrappedScrollView].
  ShrinkWrappedScrollView()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'shrink_wrapped_scroll_view';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Do nothing if the package of constructor is not `flutter`.
    final constructorName = node.constructorName;
    final library = constructorName.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    // Do nothing if the constructor is not sub class of `ScrollView`.
    if (!_scrollViewSubClasses.contains(constructorName.type.element?.name)) {
      return;
    }

    // Do nothing if the constructor doesn't have `shrinkWrap` argument.
    final arguments = node.argumentList.arguments;
    final isShrinkWrapSet = arguments.any(
      (argument) =>
          argument is NamedExpression &&
          argument.name.label.name == 'shrinkWrap',
    );
    if (!isShrinkWrapSet) return;

    // Do nothing if `shrinkWrap: true` is not set.
    final isShrinkWrapped = arguments.any(
      (argument) =>
          argument is NamedExpression &&
          argument.name.label.name == 'shrinkWrap' &&
          argument.expression is BooleanLiteral &&
          (argument.expression as BooleanLiteral).value,
    );
    if (!isShrinkWrapped) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `shrink_wrapped_scroll_view` rule.
///
/// This fix removes `shrinkWrap` argument from the scroll view constructor.
class RemoveShrinkWrap extends ResolvedCorrectionProducer {
  /// Create a new instance of [RemoveShrinkWrap].
  RemoveShrinkWrap({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.removeShrinkWrap',
    FixKindPriority.removeShrinkWrap,
    'Remove shrinkWrap',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    // Do nothing if the constructor is not sub class of `ScrollView`.
    final constructorName = instanceCreation.constructorName;
    if (!_scrollViewSubClasses.contains(constructorName.type.element?.name)) {
      return;
    }

    await builder.addDartFileEdit(file, (builder) {
      final arguments = instanceCreation.argumentList.arguments;
      final argument = arguments.firstWhere(
        (argument) =>
            argument is NamedExpression &&
            argument.name.label.name == 'shrinkWrap',
      );
      builder.addDeletion(SourceRange(argument.offset, argument.length));
    });
  }
}
