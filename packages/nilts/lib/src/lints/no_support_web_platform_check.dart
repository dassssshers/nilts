/// @docImport 'dart:io';
/// @docImport 'package:flutter/foundation.dart';
library;

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

const _description =
    'Platform check with dart:io API is not supported on web application.';

/// A class for `no_support_web_platform_check` rule.
///
/// This rule checks if
///
/// - [Platform.isLinux]
/// - [Platform.isMacOS]
/// - [Platform.isWindows]
/// - [Platform.isAndroid]
/// - [Platform.isIOS]
/// - [Platform.isFuchsia]
///
/// are used.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// Prefer using [defaultTargetPlatform] instead of [Platform] API
/// if you want to know which platform your application is running on.
/// This is because
///
/// - [Platform] API throws a runtime exception on web application.
/// - By combining [kIsWeb] and [defaultTargetPlatform], you can
/// accurately determine which platform your web application is running on.
///
/// **BAD:**
/// ```dart
/// bool get isIOS => !kIsWeb && Platform.isIOS;
/// ```
///
/// **GOOD:**
/// ```dart
/// bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
/// ```
///
/// See also:
///
/// - [defaultTargetPlatform property - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/defaultTargetPlatform.html)
class NoSupportWebPlatformCheck extends AnalysisRule {
  /// Create a new instance of [NoSupportWebPlatformCheck].
  NoSupportWebPlatformCheck()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'no_support_web_platform_check';

  /// The lint code for this rule.
  static const LintCode code = LintCode(ruleName, _description);

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addPrefixedIdentifier(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    // Do nothing if the identifier name is not
    // - `isLinux`
    // - `isMacOS`
    // - `isWindows`
    // - `isAndroid`
    // - `isIOS`
    // - `isFuchsia`
    final identifierName = node.identifier;
    if (identifierName.name != 'isLinux' &&
        identifierName.name != 'isMacOS' &&
        identifierName.name != 'isWindows' &&
        identifierName.name != 'isAndroid' &&
        identifierName.name != 'isIOS' &&
        identifierName.name != 'isFuchsia') {
      return;
    }

    // Do nothing if the package of identifier is not `dart.io`.
    final library = identifierName.element?.library;
    if (library == null) return;
    if (library.name != 'dart.io') return;

    // Do nothing if the token is not `.`.
    final period = node.period;
    if (period.type != TokenType.PERIOD) return;

    // Do nothing if prefix is not `Platform`.
    final prefix = node.prefix;
    final isPlatform = prefix.name == 'Platform';
    if (!isPlatform) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `no_support_web_platform_check` rule.
///
/// This fix replaces `Platform.isXXX` with [defaultTargetPlatform] check.
class ReplaceWithDefaultTargetPlatform extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithDefaultTargetPlatform].
  ReplaceWithDefaultTargetPlatform({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithDefaultTargetPlatform',
    FixKindPriority.replaceWithDefaultTargetPlatform,
    'Replace With defaultTargetPlatform check',
  );

  static const Map<String, String> _targetPlatformMap = {
    'isLinux': 'linux',
    'isMacOS': 'macOS',
    'isWindows': 'windows',
    'isAndroid': 'android',
    'isIOS': 'iOS',
    'isFuchsia': 'fuchsia',
  };

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! PrefixedIdentifier) return;
    final prefixedIdentifier = node as PrefixedIdentifier;

    final identifier = prefixedIdentifier.identifier.name;
    final mappedProperty = _targetPlatformMap[identifier];

    // Do nothing if the identifier is not
    // - `isLinux`
    // - `isMacOS`
    // - `isWindows`
    // - `isAndroid`
    // - `isIOS`
    // - `isFuchsia`.
    if (mappedProperty == null) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(prefixedIdentifier.offset, prefixedIdentifier.length),
        'defaultTargetPlatform == TargetPlatform.$mappedProperty',
      );
    });
  }
}
