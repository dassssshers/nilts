// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';
import 'package:nilts_core/nilts_core.dart';

const _description =
    'Using `MediaQuery.of` or `MediaQuery.maybeOf` may cause unnecessary rebuilds.';

/// All data that `MediaQueryData` depends on.
///
/// See also:
///   - For >= Flutter 3.10.0 < 3.16.0: https://github.com/flutter/flutter/blob/3.10.0/packages/flutter/lib/src/widgets/media_query.dart#L36-L73
///   - For > Flutter 3.16.0: https://github.com/flutter/flutter/blob/3.16.0/packages/flutter/lib/src/widgets/media_query.dart#L36-L77
const List<String> _propertiesForFlutter316 = [
  'size',
  'orientation',
  'devicePixelRatio',
  'textScaleFactor',
  'textScaler',
  'platformBrightness',
  'padding',
  'viewInsets',
  'systemGestureInsets',
  'viewPadding',
  'alwaysUse24HourFormat',
  'accessibleNavigation',
  'invertColors',
  'highContrast',
  'onOffSwitchLabels',
  'disableAnimations',
  'boldText',
  'navigationMode',
  'gestureSettings',
  'displayFeatures',
];
const List<String> _propertiesForFlutter310 = [
  'size',
  'orientation',
  'devicePixelRatio',
  'textScaleFactor',
  'platformBrightness',
  'padding',
  'viewInsets',
  'systemGestureInsets',
  'viewPadding',
  'alwaysUse24HourFormat',
  'accessibleNavigation',
  'invertColors',
  'highContrast',
  'disableAnimations',
  'boldText',
  'navigationMode',
  'gestureSettings',
  'displayFeatures',
];

/// A class for `unnecessary_rebuilds_from_media_query` rule.
///
/// This rule checks if
/// [MediaQuery.of] or [MediaQuery.maybeOf] is used
/// instead of `MediaQuery.xxxOf` or `MediaQuery.maybeXxxOf`.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// Prefer using
/// `MediaQuery.xxxOf` or `MediaQuery.maybeXxxOf`
/// instead of [MediaQuery.of] or [MediaQuery.maybeOf]
/// to avoid unnecessary rebuilds.
///
/// **BAD:**
/// ```dart
/// final size = MediaQuery.of(context).size;
/// ```
///
/// **GOOD:**
/// ```dart
/// final size = MediaQuery.sizeOf(context);
/// ```
///
/// **Note that using [MediaQuery.of] or [MediaQuery.maybeOf]
/// makes sense following cases:**
///
/// - wrap Widget with [MediaQuery] overridden [MediaQueryData]
/// - observe all changes of [MediaQueryData]
///
/// See also:
///
/// - [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
/// - [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
class UnnecessaryRebuildsFromMediaQuery extends AnalysisRule {
  /// Create a new instance of [UnnecessaryRebuildsFromMediaQuery].
  UnnecessaryRebuildsFromMediaQuery(this._dartVersion)
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  final DartVersion _dartVersion;

  static const String ruleName = 'unnecessary_rebuilds_from_media_query';

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
    registry.addMethodInvocation(this, _Visitor(this, context, _dartVersion));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context, this.dartVersion);

  final AnalysisRule rule;
  final RuleContext context;
  final DartVersion dartVersion;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Do nothing if the method name is not `of` and not `maybeOf`.
    final methodName = node.methodName;
    if (methodName.name != 'of' && methodName.name != 'maybeOf') return;

    // Do nothing if the method argument's type is not `BuildContext`.
    final arguments = node.argumentList.arguments;
    if (arguments.length != 1) return;
    final firstArgument = node.argumentList.arguments.first.staticType;
    if (firstArgument == null) return;
    // Check if it's BuildContext without using TypeChecker
    final firstArgumentElement = firstArgument.element;
    if (firstArgumentElement == null) return;
    if (firstArgumentElement.name != 'BuildContext') return;
    final firstArgumentLibrary = firstArgumentElement.library;
    if (firstArgumentLibrary == null) return;
    if (!firstArgumentLibrary.isFlutter) return;

    // Do nothing if the package of method is not `flutter`.
    final library = methodName.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    // Do nothing if the operator of method is not `.`.
    final operatorToken = node.operator;
    if (operatorToken?.type != TokenType.PERIOD) return;

    // Do notion if the class of method is not `MediaQuery`.
    final target = node.realTarget;
    if (target is! SimpleIdentifier) return;
    final isMediaQuery = target.name == 'MediaQuery';
    if (!isMediaQuery) return;

    rule.reportAtNode(node.methodName);
  }
}

/// A class for fixing `unnecessary_rebuilds_from_media_query` rule.
///
/// This fix replaces [MediaQuery.of] or [MediaQuery.maybeOf] with
/// [MediaQuery.xxxOf] or [MediaQuery.maybeXxxOf].
class ReplaceWithMediaQueryXxxOf extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithMediaQueryXxxOf].
  ReplaceWithMediaQueryXxxOf({
    required super.context,
    required DartVersion dartVersion,
  }) : _properties =
           dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0)
           ? _propertiesForFlutter316
           : _propertiesForFlutter310;

  final List<String> _properties;

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithMediaQueryXxxOf',
    FixKindPriority.replaceWithMediaQueryXxxOf,
    'Replace With MediaQuery.xxxOf(context)',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    // Find the PropertyAccess node that accesses the MediaQuery result
    final parent = node.parent;
    if (parent is! PropertyAccess) return;

    final propertyAccess = parent;
    final property = propertyAccess.propertyName.name;

    // Do nothing if MediaQueryData doesn't have the property.
    if (!_properties.contains(property)) return;

    final methodInvocation = node.parent?.parent;
    if (methodInvocation is! MethodInvocation) {
      // node.parent is PropertyAccess, node.parent.parent should be the method invocation's parent
      // We need to find the MethodInvocation
      final target = propertyAccess.realTarget;
      if (target is! MethodInvocation) return;

      final methodName = target.methodName.name;
      // Do nothing if the method name which the property depends on
      // is not `of` and not `maybeOf`.
      if (methodName == 'of') {
        await builder.addDartFileEdit(file, (builder) {
          builder.addSimpleReplacement(
            SourceRange(
              target.methodName.offset,
              propertyAccess.end - target.methodName.offset,
            ),
            '${property}Of(context)',
          );
        });
      } else if (methodName == 'maybeOf') {
        final maybeProperty =
            '${property[0].toUpperCase()}${property.substring(1)}';
        await builder.addDartFileEdit(file, (builder) {
          builder.addSimpleReplacement(
            SourceRange(
              target.methodName.offset,
              propertyAccess.end - target.methodName.offset,
            ),
            'maybe${maybeProperty}Of(context)',
          );
        });
      }
    }
  }
}
