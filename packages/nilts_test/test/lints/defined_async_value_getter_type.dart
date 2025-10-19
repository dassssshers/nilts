// ignore_for_file: document_ignores
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_value_getter_type
// ignore_for_file: defined_async_callback_type
// ignore_for_file: defined_async_value_setter_type
// ignore_for_file: unused_element_parameter

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class MainButton extends StatelessWidget {
  const MainButton(
    Future<void> Function() this.onPressed,
    AsyncValueGetter<int> this.onAliasPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function() this.onFutureReturnPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int?> Function() this.onFutureNullableReturnPressed,
    int Function() this.onReturnPressed, {
    Future<void> Function()? this.onNullablePressed,
    Future<void> Function(int)? this.onParamPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function()? this.onNullableFutureReturnPressed,
    int Function()? this.onNullableReturnPressed,
    super.key,
  });

  final Future<void> Function() onPressed;
  final AsyncValueGetter<int> onAliasPressed;

  // expect_lint: defined_async_value_getter_type
  final Future<int> Function() onFutureReturnPressed;

  // expect_lint: defined_async_value_getter_type
  final Future<int?> Function() onFutureNullableReturnPressed;
  final int Function() onReturnPressed;
  final Future<void> Function()? onNullablePressed;
  final Future<void> Function(int)? onParamPressed;

  // expect_lint: defined_async_value_getter_type
  final Future<int> Function()? onNullableFutureReturnPressed;
  final int Function()? onNullableReturnPressed;

  void _onPressed(
    Future<void> Function() onPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function() onFutureReturnPressed,
    int Function() onReturnPressed, {
    Future<void> Function()? onNullablePressed,
    Future<void> Function(int)? onParamPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function()? onNullableFutureReturnPressed,
    int Function()? onNullableReturnPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        _onPressed(() async {}, () async => 0, () => 0);
        return onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final Future<void> Function() globalFunction = () async {};
// expect_lint: defined_async_value_getter_type
final Future<int> Function() globalFutureReturnFunction = () async => 0;
final int Function() globalReturnFunction = () => 0;
const Future<void> Function()? globalNullableFunction = null;
const Future<void> Function(int)? globalParamFunction = null;
// expect_lint: defined_async_value_getter_type
const Future<int> Function()? globalNullableFutureReturnFunction = null;
const int Function()? globalNullableReturnFunction = null;

void _globalFunction(
  Future<void> Function() onPressed,
  // expect_lint: defined_async_value_getter_type
  Future<int> Function() onFutureReturnPressed,
  int Function() onReturnPressed, {
  Future<void> Function()? onNullablePressed,
  Future<void> Function(int)? onParamPressed,
  // expect_lint: defined_async_value_getter_type
  Future<int> Function()? onNullableFutureReturnPressed,
  int Function()? onNullableReturnPressed,
}) {}
