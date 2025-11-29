import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:nilts_flutter_hooks/src/lints/unnecessary_hook_widget.dart';

/// The Dart Analysis Server looks for this variable.
final plugin = _NiltsFlutterHooksPlugin();

/// A class for defining all lint rules, quick fixes and assists
/// managed by nilts_flutter_hooks.
class _NiltsFlutterHooksPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerLintRule(UnnecessaryHookWidget())
      ..registerFixForRule(
        UnnecessaryHookWidget.code,
        ReplaceWithStatelessWidget.new,
      );
  }

  @override
  String get name => 'nilts_flutter_hooks';
}
