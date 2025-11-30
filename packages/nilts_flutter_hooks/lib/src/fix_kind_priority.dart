/// @docImport 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
library;

/// A class for defining priorities of quick fix.
///
/// Priority to ignore rules is defined on [DartFixKindPriority.ignore] as 30.
///
/// See also:
///   - [DartFixKindPriority](https://pub.dev/documentation/analysis_server_plugin/latest/edit_dart_dart_fix_kind_priority/DartFixKindPriority-class.html)
abstract final class FixKindPriority {
  /// The priority for `_ReplaceWithStatelessWidget`
  static const int replaceWithStatelessWidget = 100;
}
