// ignore_for_file: document_ignores
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_value_changed_type
// ignore_for_file: defined_value_setter_type
// ignore_for_file: defined_void_callback_type
// ignore_for_file: defined_async_value_getter_type
// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

final class MainButton extends StatelessWidget {
  const MainButton(
    void Function() this.onPressed,
    ValueGetter<int> this.onAliasPressed,
    // expect_lint: defined_value_getter_type
    int Function() this.onReturnPressed,
    // expect_lint: defined_value_getter_type
    int? Function() this.onReturnNullablePressed,
    Future<int> Function() this.onFutureReturnPressed, {
    void Function()? this.onNullablePressed,
    void Function(int)? this.onParamPressed,
    // expect_lint: defined_value_getter_type
    int Function()? this.onNullableReturnPressed,
    Future<int> Function()? this.onNullableFutureReturnPressed,
    super.key,
  });

  final void Function() onPressed;
  final ValueGetter<int> onAliasPressed;
  // expect_lint: defined_value_getter_type
  final int Function() onReturnPressed;
  // expect_lint: defined_value_getter_type
  final int? Function() onReturnNullablePressed;
  final Future<int> Function() onFutureReturnPressed;
  final void Function()? onNullablePressed;
  final void Function(int)? onParamPressed;
  // expect_lint: defined_value_getter_type
  final int Function()? onNullableReturnPressed;
  final Future<int> Function()? onNullableFutureReturnPressed;

  void _onPressed(
    void Function() onPressed,
    // expect_lint: defined_value_getter_type
    int Function() onReturnPressed,
    Future<int> Function() onFutureReturnPressed, {
    void Function()? onNullablePressed,
    void Function(int)? onParamPressed,
    // expect_lint: defined_value_getter_type
    int Function()? onNullableReturnPressed,
    Future<int> Function()? onNullableFutureReturnPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _onPressed(() {}, () => 0, () async => 0);
        onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final void Function() globalFunction = () {};
// expect_lint: defined_value_getter_type
final int Function() globalReturnFunction = () => 0;
final Future<int> Function() globalFutureReturnFunction = () async => 0;
const void Function()? globalNullableFunction = null;
const void Function(int)? globalParamFunction = null;
// expect_lint: defined_value_getter_type
const int Function()? globalNullableReturnFunction = null;
const Future<int> Function()? globalNullableFutureReturnFunction = null;

void _globalFunction(
  void Function() onPressed,
  // expect_lint: defined_value_getter_type
  int Function() onReturnPressed,
  Future<int> Function() onFutureReturnPressed, {
  void Function()? onNullablePressed,
  void Function(int)? onParamPressed,
  // expect_lint: defined_value_getter_type
  int Function()? onNullableReturnPressed,
  Future<int> Function()? onNullableFutureReturnPressed,
}) {}
