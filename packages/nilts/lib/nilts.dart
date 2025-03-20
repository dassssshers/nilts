import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/lints/defined_async_callback_type.dart';
import 'package:nilts/src/lints/defined_async_value_getter_type.dart';
import 'package:nilts/src/lints/defined_async_value_setter_type.dart';
import 'package:nilts/src/lints/defined_value_callback_type.dart';
import 'package:nilts/src/lints/defined_value_getter_type.dart';
import 'package:nilts/src/lints/defined_void_callback_type.dart';
import 'package:nilts/src/lints/fixed_text_scale_rich_text.dart';
import 'package:nilts/src/lints/flaky_tests_with_set_up_all.dart';
import 'package:nilts/src/lints/low_readability_numeric_literals.dart';
import 'package:nilts/src/lints/no_support_multi_text_direction.dart';
import 'package:nilts/src/lints/no_support_web_platform_check.dart';
import 'package:nilts/src/lints/shrink_wrapped_scroll_view.dart';
import 'package:nilts/src/lints/unnecessary_rebuilds_from_media_query.dart';
import 'package:nilts/src/lints/unstable_enum_name.dart';
import 'package:nilts/src/lints/unstable_enum_values.dart';
import 'package:nilts_core/nilts_core.dart';

/// custom_lint integrates the nilts's plugin from this method on
/// `custom_lint_client.dart` which is generated by custom_lint CLI.
PluginBase createPlugin() => _NiltsLint();

/// A class for defining all lint rules and assists managed by nilts.
class _NiltsLint extends PluginBase {
  final _dartVersion = DartVersion.fromPlatform();

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const DefinedAsyncCallbackType(),
        const DefinedAsyncValueGetterType(),
        const DefinedAsyncValueSetterType(),
        const DefinedValueChangedType(),
        const DefinedValueGetterType(),
        const DefinedValueSetterType(),
        const DefinedVoidCallbackType(),
        if (_dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0))
          const FixedTextScaleRichText()
        else
          const FixedTextScaleRichTextLegacy(),
        const FlakyTestsWithSetUpAll(),
        if (_dartVersion >= const DartVersion(major: 3, minor: 6, patch: 0))
          const LowReadabilityNumericLiterals(),
        const NoSupportMultiTextDirection(),
        const NoSupportWebPlatformCheck(),
        const ShrinkWrappedScrollView(),
        if (_dartVersion >= const DartVersion(major: 3, minor: 0, patch: 0))
          UnnecessaryRebuildsFromMediaQuery(_dartVersion),
        const UnstableEnumName(),
        const UnstableEnumValues(),
      ];
}
