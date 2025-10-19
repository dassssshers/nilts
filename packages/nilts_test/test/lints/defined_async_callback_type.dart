// ignore_for_file: document_ignores
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_async_value_setter_type
// ignore_for_file: defined_async_value_getter_type
// ignore_for_file: unused_element_parameter

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class MainButton extends StatelessWidget {
  const MainButton(
    // expect_lint: defined_async_callback_type
    Future<void> Function() this.onPressed,
    AsyncCallback this.onAliasPressed, {
    // expect_lint: defined_async_callback_type
    Future<void> Function()? this.onNullablePressed,
    Future<void> Function(int)? this.onParamPressed,
    Future<int> Function()? this.onNotVoidPressed,
    super.key,
  });

  // expect_lint: defined_async_callback_type
  final Future<void> Function() onPressed;
  final AsyncCallback onAliasPressed;
  // expect_lint: defined_async_callback_type
  final Future<void> Function()? onNullablePressed;
  final Future<void> Function(int)? onParamPressed;
  final Future<int> Function()? onNotVoidPressed;

  void _onPressed(
    // expect_lint: defined_async_callback_type
    Future<void> Function() onPressed, {
    // expect_lint: defined_async_callback_type
    Future<void> Function()? onNullablePressed,
    Future<void> Function(int)? onParamPressed,
    Future<int> Function()? onNotVoidPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        _onPressed(() async {});
        return onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

// expect_lint: defined_async_callback_type
final Future<void> Function() globalFunction = () async {};
// expect_lint: defined_async_callback_type
const Future<void> Function()? globalNullableFunction = null;
const Future<void> Function(int)? globalParamFunction = null;
const Future<int> Function()? globalNotVoidFunction = null;

void _globalFunction(
  // expect_lint: defined_async_callback_type
  Future<void> Function() onPressed, {
  // expect_lint: defined_async_callback_type
  Future<void> Function()? onNullablePressed,
  Future<void> Function(int)? onParamPressed,
  Future<int> Function()? onNotVoidPressed,
}) {}
