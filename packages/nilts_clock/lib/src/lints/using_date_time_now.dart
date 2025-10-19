import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts_clock/src/change_priority.dart';

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
/// - Maturity level : Experimental
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
class UsingDateTimeNow extends DartLintRule {
  /// Create a new instance of [UsingDateTimeNow].
  const UsingDateTimeNow() : super(code: _code);

  static const _code = LintCode(
    name: 'using_date_time_now',
    problemMessage: "Don't use DateTime.now()",
    url: 'https://github.com/dassssshers/nilts#using_date_time_now',
  );

  @override
  void run(
    CustomLintResolver _,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.constructorName.element;
      if (element == null) return;
      if (!element.library.isDartCore) return;
      if (element.name != _dateTimeNowConstructorName) return;

      final type = node.constructorName.type;
      if (type.element?.name != _dateTimeClassName) return;

      reporter.atNode(node, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithClockNow(),
      ];
}

class _ReplaceWithClockNow extends DartFix {
  @override
  void run(
    CustomLintResolver _,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> __,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      final clazz = node.constructorName.type;

      reporter
          .createChangeBuilder(
        message: 'Replace With $_clockGetterName',
        priority: ChangePriority.replaceWithClockNow,
      )
          .addDartFileEdit((builder) {
        final uri = Uri.parse(_clockPackageUri);
        if (!builder.importsLibrary(uri)) {
          builder.importLibrary(uri);
        }
        builder.addSimpleReplacement(
          SourceRange(clazz.offset, clazz.length),
          _clockGetterName,
        );
      });
    });
  }
}
