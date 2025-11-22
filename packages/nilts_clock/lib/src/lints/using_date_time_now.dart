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
import 'package:nilts_clock/src/fix_kind_priority.dart';

const _description = "Don't use DateTime.now()";

const _dateTimeClassName = 'DateTime';
const _dateTimeNowConstructorName = 'now';

const _clockPackageUri = 'package:clock/clock.dart';
const _clockGetterName = 'clock';

/// A class for `using_date_time_now` rule.
///
/// This rule checks if [DateTime.now] is used.
///
/// - Target SDK     : Any versions nilts_clock supports
/// - Rule type      : ErrorProne
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **DON'T** use `DateTime.now()`.
/// If your project depends on `clock` package and
/// expects current time is encapsulated,
/// always use `clock.now()` instead for consistency.
///
/// **BAD:**
/// ```dart
/// final dateTimeNow = DateTime.now();
/// ```
///
/// **GOOD:**
/// ```dart
/// final clockNow = clock.now();
/// ```
///
/// See also:
/// - [clock | Dart package](https://pub.dev/packages/clock)
class UsingDateTimeNow extends AnalysisRule {
  /// Create a new instance of [UsingDateTimeNow].
  UsingDateTimeNow()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  static const String ruleName = 'using_date_time_now';

  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Replace with clock.now()',
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
    final element = node.constructorName.element;
    if (element == null) return;
    if (!element.library.isDartCore) return;
    if (element.name != _dateTimeNowConstructorName) return;

    final type = node.constructorName.type;
    if (type.element?.name != _dateTimeClassName) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `using_date_time_now` rule.
///
/// This fix replace `DateTime.now()` with `clock.now()`.
class ReplaceWithClockNow extends ResolvedCorrectionProducer {
  /// Create a new instance of [UsingDateTimeNow].
  ReplaceWithClockNow({required super.context});

  static const _fixKind = FixKind(
    'nilts_clock.fix.replaceWithClockNow',
    FixKindPriority.replaceWithClockNow,
    'Replace With $_clockGetterName',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final clazz = (node as InstanceCreationExpression).constructorName.type;
    await builder.addDartFileEdit(file, (builder) {
      final uri = Uri.parse(_clockPackageUri);
      if (!builder.importsLibrary(uri)) {
        builder.importLibrary(uri);
      }
      builder.addSimpleReplacement(
        SourceRange(clazz.offset, clazz.length),
        _clockGetterName,
      );
    });
  }
}
