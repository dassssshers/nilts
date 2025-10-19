// ignore_for_file: document_ignores
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_async_callback_type
// ignore_for_file: defined_async_value_getter_type
// ignore_for_file: unused_element_parameter

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class MainButton extends StatelessWidget {
  const MainButton(
    Future<void> Function() this.onPressed,
    AsyncValueSetter<int> this.onAliasPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int) this.onParamPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int?) this.onParamNullablePressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int value) this.onNamedParamPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int? value) this.onNamedParamNullablePressed,
    Future<void> Function({int value}) this.onOptionalParamPressed,
    Future<void> Function({required int value}) this.onRequiredParamPressed, {
    Future<void> Function()? this.onNullablePressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int)? this.onNullableParamPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int value)? this.onNullableNamedParamPressed,
    Future<int> Function()? this.onNotVoidPressed,
    super.key,
  });

  final Future<void> Function() onPressed;
  final AsyncValueSetter<int> onAliasPressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int) onParamPressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int?) onParamNullablePressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int value) onNamedParamPressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int? value) onNamedParamNullablePressed;
  final Future<void> Function({int value}) onOptionalParamPressed;
  final Future<void> Function({required int value}) onRequiredParamPressed;
  final Future<void> Function()? onNullablePressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int)? onNullableParamPressed;

  // expect_lint: defined_async_value_setter_type
  final Future<void> Function(int value)? onNullableNamedParamPressed;
  final Future<int> Function()? onNotVoidPressed;

  void _onPressed(
    Future<void> Function() onPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int) onParamPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int value) onNamedParamPressed,
    Future<void> Function({int? value}) onOptionalParamPressed,
    Future<void> Function({required int value}) onRequiredParamPressed, {
    Future<void> Function()? onNullablePressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int)? onNullableParamPressed,
    // expect_lint: defined_async_value_setter_type
    Future<void> Function(int value)? onNullableNamedParamPressed,
    Future<int> Function()? onNotVoidPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        _onPressed(
          () async {},
          (value) async {},
          (value) async {},
          ({value}) async {},
          ({required int value}) async {},
        );
        return onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final Future<void> Function() globalFunction = () async {};
// expect_lint: defined_async_value_setter_type
final Future<void> Function(int) globalParamFunction = (value) async {};
// expect_lint: defined_async_value_setter_type
final Future<void> Function(int value) globalNamedParamFunction =
    (value) async {};
final Future<void> Function({int? value}) globalOptionalParamFunction =
    ({value}) async {};
final Future<void> Function({required int value}) globalRequiredParamFunction =
    ({required value}) async {};
const Future<void> Function()? globalNullableFunction = null;
// expect_lint: defined_async_value_setter_type
const Future<void> Function(int)? globalNullableParamFunction = null;
// expect_lint: defined_async_value_setter_type
const Future<void> Function(int value)? globalNullableNamedParamFunction = null;
const Future<int> Function()? globalNotVoidFunction = null;

void _globalFunction(
  Future<void> Function() onPressed,
  // expect_lint: defined_async_value_setter_type
  Future<void> Function(int) onParamPressed,
  // expect_lint: defined_async_value_setter_type
  Future<void> Function(int value) onNamedParamPressed,
  Future<void> Function({int? value}) onOptionalParamPressed,
  Future<void> Function({required int value}) onRequiredParamPressed, {
  Future<void> Function()? onNullablePressed,
  // expect_lint: defined_async_value_setter_type
  Future<void> Function(int)? onNullableParamPressed,
  // expect_lint: defined_async_value_setter_type
  Future<void> Function(int value)? onNullableNamedParamPressed,
  Future<int> Function()? onNotVoidPressed,
}) {}
