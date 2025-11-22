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
      ..registerWarningRule(DefinedAsyncCallbackType())
      ..registerFixForRule(
        DefinedAsyncCallbackType.code,
        ReplaceWithAsyncCallback.new,
      )
      ..registerWarningRule(DefinedAsyncValueGetterType())
      ..registerFixForRule(
        DefinedAsyncValueGetterType.code,
        ReplaceWithAsyncValueGetter.new,
      )
      ..registerWarningRule(DefinedAsyncValueSetterType())
      ..registerFixForRule(
        DefinedAsyncValueSetterType.code,
        ReplaceWithAsyncValueSetter.new,
      )
      ..registerWarningRule(DefinedValueChangedType())
      ..registerFixForRule(
        DefinedValueChangedType.code,
        ReplaceWithValueChanged.new,
      )
      ..registerWarningRule(DefinedValueGetterType())
      ..registerFixForRule(
        DefinedValueGetterType.code,
        ReplaceWithValueGetter.new,
      )
      ..registerWarningRule(DefinedValueSetterType())
      ..registerFixForRule(
        DefinedValueSetterType.code,
        ReplaceWithValueSetter.new,
      )
      ..registerWarningRule(DefinedVoidCallbackType())
      ..registerFixForRule(
        DefinedVoidCallbackType.code,
        ReplaceWithVoidCallback.new,
      )
      ..registerWarningRule(UnsafeNullAssertion())
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
      ..registerWarningRule(UnstableEnumName())
      ..registerWarningRule(UnstableEnumValues())
      // Newly migrated rules
      ..registerWarningRule(OpenTypeHierarchy())
      ..registerFixForRule(
        OpenTypeHierarchy.code,
        AddFinalKeyword.new,
      )
      ..registerWarningRule(
        dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0)
            ? FixedTextScaleRichText()
            : FixedTextScaleRichTextLegacy(),
      )
      ..registerFixForRule(
        FixedTextScaleRichText.code,
        ReplaceWithTextRich.new,
      )
      ..registerFixForRule(
        FixedTextScaleRichText.code,
        dartVersion >= const DartVersion(major: 3, minor: 2, patch: 0)
            ? AddTextScaler.new
            : AddTextScaleFactor.new,
      )
      ..registerWarningRule(FlakyTestsWithSetUpAll())
      ..registerFixForRule(
        FlakyTestsWithSetUpAll.code,
        ReplaceWithSetUp.new,
      )
      ..registerFixForRule(
        FlakyTestsWithSetUpAll.code,
        UnwrapSetUpAll.new,
      )
      ..registerWarningRule(LowReadabilityNumericLiterals())
      ..registerFixForRule(
        LowReadabilityNumericLiterals.code,
        AddDigitSeparators.new,
      )
      ..registerWarningRule(NoSupportMultiTextDirection())
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
      ..registerWarningRule(NoSupportWebPlatformCheck())
      ..registerFixForRule(
        NoSupportWebPlatformCheck.code,
        ReplaceWithDefaultTargetPlatform.new,
      )
      ..registerWarningRule(ShrinkWrappedScrollView())
      ..registerFixForRule(
        ShrinkWrappedScrollView.code,
        RemoveShrinkWrap.new,
      )
      ..registerWarningRule(UnnecessaryRebuildsFromMediaQuery(dartVersion))
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
