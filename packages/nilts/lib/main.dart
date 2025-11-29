import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:nilts/src/lints/defined_async_callback_type.dart';
import 'package:nilts/src/lints/defined_async_value_getter_type.dart';
import 'package:nilts/src/lints/defined_async_value_setter_type.dart';
import 'package:nilts/src/lints/defined_value_changed_type.dart';
import 'package:nilts/src/lints/defined_value_getter_type.dart';
import 'package:nilts/src/lints/defined_value_setter_type.dart';
import 'package:nilts/src/lints/defined_void_callback_type.dart';
import 'package:nilts/src/lints/fixed_text_scale_rich_text.dart';
import 'package:nilts/src/lints/flaky_tests_with_set_up_all.dart';
import 'package:nilts/src/lints/low_readability_numeric_literals.dart';
import 'package:nilts/src/lints/no_support_multi_text_direction.dart';
import 'package:nilts/src/lints/no_support_web_platform_check.dart';
import 'package:nilts/src/lints/open_type_hierarchy.dart';
import 'package:nilts/src/lints/shrink_wrapped_scroll_view.dart';
import 'package:nilts/src/lints/unnecessary_rebuilds_from_media_query.dart';
import 'package:nilts/src/lints/unsafe_null_assertion.dart';
import 'package:nilts/src/lints/unstable_enum_name.dart';
import 'package:nilts/src/lints/unstable_enum_values.dart';
import 'package:nilts_core/nilts_core.dart';

/// The Dart Analysis Server looks for this variable.
final plugin = _NiltsPlugin();

/// A class for defining all lint rules, quick fixes and assists
/// managed by nilts.
class _NiltsPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    // Get Dart version for version-dependent rules
    final dartVersion = DartVersion.fromPlatform();

    registry
      ..registerLintRule(DefinedAsyncCallbackType())
      ..registerFixForRule(
        DefinedAsyncCallbackType.code,
        ReplaceWithAsyncCallback.new,
      )
      ..registerLintRule(DefinedAsyncValueGetterType())
      ..registerFixForRule(
        DefinedAsyncValueGetterType.code,
        ReplaceWithAsyncValueGetter.new,
      )
      ..registerLintRule(DefinedAsyncValueSetterType())
      ..registerFixForRule(
        DefinedAsyncValueSetterType.code,
        ReplaceWithAsyncValueSetter.new,
      )
      ..registerLintRule(DefinedValueChangedType())
      ..registerFixForRule(
        DefinedValueChangedType.code,
        ReplaceWithValueChanged.new,
      )
      ..registerLintRule(DefinedValueGetterType())
      ..registerFixForRule(
        DefinedValueGetterType.code,
        ReplaceWithValueGetter.new,
      )
      ..registerLintRule(DefinedValueSetterType())
      ..registerFixForRule(
        DefinedValueSetterType.code,
        ReplaceWithValueSetter.new,
      )
      ..registerLintRule(DefinedVoidCallbackType())
      ..registerFixForRule(
        DefinedVoidCallbackType.code,
        ReplaceWithVoidCallback.new,
      )
      ..registerLintRule(UnsafeNullAssertion())
      ..registerFixForRule(
        UnsafeNullAssertion.code,
        ReplaceWithIfNullOperator.new,
      )
      ..registerFixForRule(
        UnsafeNullAssertion.code,
        ReplaceWithNullAwareOperator.new,
      )
      ..registerFixForRule(
        UnsafeNullAssertion.code,
        ReplaceWithPatternMatching.new,
      )
      ..registerLintRule(UnstableEnumName())
      ..registerLintRule(UnstableEnumValues())
      // Newly migrated rules
      ..registerLintRule(OpenTypeHierarchy())
      ..registerFixForRule(OpenTypeHierarchy.code, AddFinalKeyword.new)
      ..registerLintRule(
        dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0)
            ? FixedTextScaleRichText()
            : FixedTextScaleRichTextLegacy(),
      )
      ..registerFixForRule(FixedTextScaleRichText.code, ReplaceWithTextRich.new)
      ..registerFixForRule(
        FixedTextScaleRichText.code,
        dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0)
            ? AddTextScaler.new
            : AddTextScaleFactor.new,
      )
      ..registerLintRule(FlakyTestsWithSetUpAll())
      ..registerFixForRule(FlakyTestsWithSetUpAll.code, ReplaceWithSetUp.new)
      ..registerFixForRule(FlakyTestsWithSetUpAll.code, UnwrapSetUpAll.new)
      ..registerLintRule(LowReadabilityNumericLiterals())
      ..registerFixForRule(
        LowReadabilityNumericLiterals.code,
        AddDigitSeparators.new,
      )
      ..registerLintRule(NoSupportMultiTextDirection())
      ..registerFixForRule(
        NoSupportMultiTextDirection.code,
        ReplaceWithAlignmentDirectional.new,
      )
      ..registerFixForRule(
        NoSupportMultiTextDirection.code,
        ReplaceWithEdgeInsetsDirectional.new,
      )
      ..registerFixForRule(
        NoSupportMultiTextDirection.code,
        ReplaceWithPositionedDirectionalClass.new,
      )
      ..registerFixForRule(
        NoSupportMultiTextDirection.code,
        ReplaceWithPositionedDirectional.new,
      )
      ..registerLintRule(NoSupportWebPlatformCheck())
      ..registerFixForRule(
        NoSupportWebPlatformCheck.code,
        ReplaceWithDefaultTargetPlatform.new,
      )
      ..registerLintRule(ShrinkWrappedScrollView())
      ..registerFixForRule(ShrinkWrappedScrollView.code, RemoveShrinkWrap.new)
      ..registerLintRule(UnnecessaryRebuildsFromMediaQuery(dartVersion))
      ..registerFixForRule(
        UnnecessaryRebuildsFromMediaQuery.code,
        ({required context}) => ReplaceWithMediaQueryXxxOf(
          context: context,
          dartVersion: dartVersion,
        ),
      );
  }

  @override
  String get name => 'nilts';
}
