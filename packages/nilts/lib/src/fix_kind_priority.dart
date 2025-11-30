/// A class for defining priorities of quick fix.
///
/// Priority to ignore rules is defined on [DartFixKindPriority.ignore] as 30.
///
/// See also:
///   - [DartFixKindPriority](https://pub.dev/documentation/analysis_server_plugin/latest/edit_dart_dart_fix_kind_priority/DartFixKindPriority-class.html)
abstract final class FixKindPriority {
  /// The priority for [_AddDigitSeparators]
  static const int addDigitSeparators = 100;

  /// The priority for [_AddTextScaleFactor]
  static const int addTextScaleFactor = 90;

  /// The priority for [_AddTextScaler]
  static const int addTextScaler = 90;

  /// The priority for [_RemoveShrinkWrap]
  static const int removeShrinkWrap = 100;

  /// The priority for [_ReplaceWithAlignmentDirectional]
  static const int replaceWithAlignmentDirectional = 100;

  /// The priority for [_ReplaceWithAsyncCallback]
  static const int replaceWithAsyncCallback = 100;

  /// The priority for [_ReplaceWithAsyncValueGetter]
  static const int replaceWithAsyncValueGetter = 100;

  /// The priority for [_ReplaceWithAsyncValueSetter]
  static const int replaceWithAsyncValueSetter = 100;

  /// The priority for [_ReplaceWithDefaultTargetPlatform]
  static const int replaceWithDefaultTargetPlatform = 100;

  /// The priority for [_ReplaceWithEdgeInsetsDirectional]
  static const int replaceWithEdgeInsetsDirectional = 100;

  /// The priority for [_ReplaceWithIfNullOperator]
  static const int replaceWithIfNullOperator = 80;

  /// The priority for [_ReplaceWithMediaQueryXxxOf]
  static const int replaceWithMediaQueryXxxOf = 100;

  /// The priority for [_ReplaceWithNullAwareOperator]
  static const int replaceWithNullAwareOperator = 90;

  /// The priority for [_ReplaceWithPatternMatching]
  static const int replaceWithPatternMatching = 100;

  /// The priority for [_ReplaceWithPositionedDirectional]
  static const int replaceWithPositionedDirectional = 90;

  /// The priority for [_ReplaceWithPositionedDirectionalClass]
  static const int replaceWithPositionedDirectionalClass = 100;

  /// The priority for [_ReplaceWithSetUp]
  static const int replaceWithSetUp = 100;

  /// The priority for [_ReplaceWithTextRich]
  static const int replaceWithTextRich = 100;

  /// The priority for [_ReplaceWithValueChanged]
  static const int replaceWithValueChanged = 100;

  /// The priority for [_ReplaceWithValueGetter]
  static const int replaceWithValueGetter = 100;

  /// The priority for [_ReplaceWithValueSetter]
  static const int replaceWithValueSetter = 100;

  /// The priority for [_ReplaceWithVoidCallback]
  static const int replaceWithVoidCallback = 100;

  /// The priority for [_UnwrapSetUpAll]
  static const int unwrapSetUpAll = 90;

  /// The priority for [_AddFinalKeyword]
  static const int addFinalKeyword = 100;
}
