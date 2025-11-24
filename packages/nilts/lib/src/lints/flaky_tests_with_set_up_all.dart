// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';
import 'package:nilts_core/nilts_core.dart';

const _description =
    '`setUpAll` may cause flaky tests with concurrency executions.';

/// A class for `flaky_tests_with_set_up_all` rule.
///
/// This rule checks if [setUpAll] is used.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** using [setUp] function or
/// initialization on top level or body of test group.
/// [setUpAll] may cause flaky tests with concurrency executions.
///
/// **BAD:**
/// ```dart
/// setUpAll(() {
///   // ...
/// });
/// ```
///
/// **GOOD:**
/// ```dart
/// setUp(() {
///   // ...
/// });
/// ```
///
/// ```dart
/// void main() {
///   // do initialization on top level
///   // ...
///
///  group('...', () {
///   // or do initialization on body of test group
///   // ...
///  });
/// }
/// ```
///
/// See also:
///
/// - [setUpAll function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUpAll.html)
/// - [setUp function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUp.html)
class FlakyTestsWithSetUpAll extends AnalysisRule {
  /// Create a new instance of [FlakyTestsWithSetUpAll].
  FlakyTestsWithSetUpAll()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'flaky_tests_with_set_up_all';

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
    registry.addMethodInvocation(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Do nothing if the method name is not `setUpAll`.
    final methodName = node.methodName;
    if (methodName.name != 'setUpAll') return;

    // Do nothing if the method argument's type is not `Function`.
    final arguments = node.argumentList.arguments;
    if (arguments.length != 1) return;
    final firstArgument = node.argumentList.arguments.first.staticType;
    if (firstArgument == null) return;
    if (firstArgument is! FunctionType) return;

    // Do nothing if the package of method is not `flutter_test`.
    final library = methodName.element?.library;
    if (library == null) return;
    if (!library.isFlutterTest) return;

    rule.reportAtNode(node.methodName);
  }
}

/// A class for fixing `flaky_tests_with_set_up_all` rule.
///
/// This fix replaces [setUpAll] with [setUp].
class ReplaceWithSetUp extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithSetUp].
  ReplaceWithSetUp({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithSetUp',
    FixKindPriority.replaceWithSetUp,
    'Replace With setUp',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! SimpleIdentifier) return;
    final parent = node.parent;
    if (parent is! MethodInvocation) return;

    // Do nothing if the method name is not `setUpAll`.
    final methodName = parent.methodName;
    if (methodName.name != 'setUpAll') return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(parent.methodName.offset, parent.methodName.length),
        'setUp',
      );
    });
  }
}

/// A class for fixing `flaky_tests_with_set_up_all` rule.
///
/// This fix unwraps [setUpAll] call and moves the body to the outer scope.
class UnwrapSetUpAll extends ResolvedCorrectionProducer {
  /// Create a new instance of [UnwrapSetUpAll].
  UnwrapSetUpAll({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.unwrapSetUpAll',
    FixKindPriority.unwrapSetUpAll,
    'Unwrap setUpAll',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! SimpleIdentifier) return;
    final parent = node.parent;
    if (parent is! MethodInvocation) return;

    // Do nothing if the method name is not `setUpAll`.
    final methodName = parent.methodName;
    if (methodName.name != 'setUpAll') return;

    await builder.addDartFileEdit(file, (builder) {
      final arguments = parent.argumentList;
      final functionArgument = arguments.arguments.first;
      // Do nothing if the function argument is not `Function`.
      if (functionArgument is! FunctionExpression) return;

      final parameters = functionArgument.parameters;
      final typeParameters = functionArgument.typeParameters;
      final functionBody = functionArgument.body;
      final star = functionBody.star;
      final keyword = functionBody.keyword;

      // Delete `);`.
      builder
        ..addDeletion(SourceRange(parent.endToken.end, 1))
        ..addDeletion(
          SourceRange(parent.endToken.offset, parent.endToken.length),
        );

      if (functionBody is BlockFunctionBody) {
        // Delete `{` and `}`.
        builder
          ..addDeletion(
            SourceRange(
              functionBody.block.leftBracket.offset,
              functionBody.block.leftBracket.length,
            ),
          )
          ..addDeletion(
            SourceRange(
              functionBody.block.rightBracket.offset,
              functionBody.block.rightBracket.length,
            ),
          );
      } else if (functionBody is ExpressionFunctionBody) {
        // Delete `=>`.
        builder.addDeletion(
          SourceRange(
            functionBody.functionDefinition.offset,
            functionBody.functionDefinition.length,
          ),
        );
      }

      // Delete `*`.
      if (star != null) {
        builder.addDeletion(SourceRange(star.offset, star.length));
      }
      // Delete `async`.
      if (keyword != null) {
        builder.addDeletion(SourceRange(keyword.offset, keyword.length));
      }
      // Delete `(...)`.
      if (parameters != null) {
        builder.addDeletion(SourceRange(parameters.offset, parameters.length));
      }
      // Delete `<...>`.
      if (typeParameters != null) {
        builder.addDeletion(
          SourceRange(typeParameters.offset, typeParameters.length),
        );
      }
      // Delete `setUpAll(`.
      builder.addDeletion(
        SourceRange(
          parent.methodName.offset,
          parent.argumentList.leftParenthesis.end - parent.methodName.offset,
        ),
      );
    });
  }
}
