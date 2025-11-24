import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';

const _description =
    'This class is intended to be neither extended nor implemented.';
const _correctionMessage =
    'Try adding class modifiers to the class declaration.';

/// A class for `open_type_hierarchy` rule.
///
/// This rule checks if the class is intended to be neither extended nor
/// implemented.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** adding a class modifier (final, sealed, etc.) to explicitly
/// define the inheritance policy of your class.
///
/// **BAD:**
/// ```dart
/// class MyClass {}
/// ```
///
/// **GOOD:**
/// ```dart
/// final class MyClass {}
/// ```
class OpenTypeHierarchy extends AnalysisRule {
  /// Create a new instance of [OpenTypeHierarchy].
  OpenTypeHierarchy()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'open_type_hierarchy';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: _correctionMessage,
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
    // Do nothing if the class has a modifier keyword
    // final, sealed, base, etc.
    if (node.classKeyword.previous?.keyword != null) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `open_type_hierarchy` rule.
///
/// This fix adds `final` keyword to the class declaration.
class AddFinalKeyword extends ResolvedCorrectionProducer {
  /// Create a new instance of [AddFinalKeyword].
  AddFinalKeyword({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.addFinalKeyword',
    FixKindPriority.addFinalKeyword,
    'Add final keyword',
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
    if (parent is! NamedCompilationUnitMember) return;
    if (parent is! ClassDeclaration) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(
        parent.classKeyword.offset,
        'final ',
      );
    });
  }
}
