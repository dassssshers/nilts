import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:nilts_clock/src/lints/using_date_time_now.dart';

/// The Dart Analysis Server looks for this variable.
final plugin = _NiltsClockPlugin();

/// A class for defining all lint rules, quick fixes and assists
/// managed by nilts_clock.
class _NiltsClockPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerLintRule(UsingDateTimeNow())
      ..registerFixForRule(UsingDateTimeNow.code, ReplaceWithClockNow.new);
  }

  @override
  String get name => 'nilts_clock';
}
