import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// expect_lint: unnecessary_hook_widget
final class FailedNoHooks extends HookWidget {
  const FailedNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}

// expect_lint: unnecessary_hook_widget
final class FailedWithWidgetNoHooks extends HookWidget
    with WidgetsBindingObserver {
  const FailedWithWidgetNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}

final class UseHooks extends HookWidget {
  const UseHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useRef(0);
    final _ = useFocusNode();
    return const Text('Hello World!');
  }
}

final class UseHooks2 extends HookWidget {
  const UseHooks2({super.key});

  @override
  Widget build(BuildContext context) {
    useTextEditingController(text: '0');
    return const Text('Hello World!');
  }
}

final class WithWidgetUseHooks extends HookWidget with WidgetsBindingObserver {
  const WithWidgetUseHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useRef(0);
    final _ = useFocusNode();
    return const Text('Hello World!');
  }
}

final class NoHooks extends StatelessWidget {
  const NoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}

final class WithWidgetNoHooks extends StatelessWidget
    with WidgetsBindingObserver {
  const WithWidgetNoHooks({super.key});

  @override
  Widget build(BuildContext context) => const Text('Hello World!');
}

final class UseCustomHooks extends HookWidget {
  const UseCustomHooks({super.key});

  @override
  Widget build(BuildContext context) {
    useCustom();
    final _ = useCustom();
    return const Text('Hello World!');
  }
}

final class UseCustomPrivateHooks extends HookWidget {
  const UseCustomPrivateHooks({super.key});

  @override
  Widget build(BuildContext context) {
    _useCustomPrivate();
    final _ = _useCustomPrivate();
    return const Text('Hello World!');
  }
}

UseCustomHook useCustom() {
  return UseCustomHook();
}

UseCustomHook _useCustomPrivate() {
  return UseCustomHook();
}

final class UseCustomHook {
  UseCustomHook();
}
