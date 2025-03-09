// ignore_for_file: document_ignores
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_void_callback_type
// ignore_for_file: defined_value_getter_type
// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

final class MainButton extends StatelessWidget {
  const MainButton(
    void Function() this.onPressed,
    ValueChanged<int> this.onChangedAliasPressed,
    ValueSetter<int> this.onSetterAliasPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int) this.onParamPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int?) this.onParamNullablePressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int value) this.onNamedParamPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int? value) this.onNamedParamNullablePressed,
    void Function({int value}) this.onOptionalParamPressed,
    void Function({required int value}) this.onRequiredParamPressed, {
    void Function()? this.onNullablePressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int)? this.onNullableParamPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int value)? this.onNullableNamedParamPressed,
    int Function()? this.onNotVoidPressed,
    super.key,
  });

  final void Function() onPressed;
  final ValueChanged<int> onChangedAliasPressed;
  final ValueSetter<int> onSetterAliasPressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int) onParamPressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int?) onParamNullablePressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int value) onNamedParamPressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int? value) onNamedParamNullablePressed;
  final void Function({int value}) onOptionalParamPressed;
  final void Function({required int value}) onRequiredParamPressed;
  final void Function()? onNullablePressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int)? onNullableParamPressed;
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  final void Function(int value)? onNullableNamedParamPressed;
  final int Function()? onNotVoidPressed;

  void _onPressed(
    void Function() onPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int) onParamPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int value) onNamedParamPressed,
    void Function({int? value}) onOptionalParamPressed,
    void Function({required int value}) onRequiredParamPressed, {
    void Function()? onNullablePressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int)? onNullableParamPressed,
    // expect_lint: defined_value_changed_type, defined_value_setter_type
    void Function(int value)? onNullableNamedParamPressed,
    int Function()? onNotVoidPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _onPressed(
          () {},
          (value) {},
          (value) {},
          ({value}) {},
          ({required int value}) {},
        );
        onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final void Function() globalFunction = () {};
// expect_lint: defined_value_changed_type, defined_value_setter_type
final void Function(int) globalParamFunction = (value) {};
// expect_lint: defined_value_changed_type, defined_value_setter_type
final void Function(int value) globalNamedParamFunction = (value) {};
final void Function({int? value}) globalOptionalParamFunction = ({value}) {};
final void Function({required int value}) globalRequiredParamFunction =
    ({required value}) {};
const void Function()? globalNullableFunction = null;
// expect_lint: defined_value_changed_type, defined_value_setter_type
const void Function(int)? globalNullableParamFunction = null;
// expect_lint: defined_value_changed_type, defined_value_setter_type
const void Function(int value)? globalNullableNamedParamFunction = null;
const int Function()? globalNotVoidFunction = null;

void _globalFunction(
  void Function() onPressed,
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  void Function(int) onParamPressed,
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  void Function(int value) onNamedParamPressed,
  void Function({int? value}) onOptionalParamPressed,
  void Function({required int value}) onRequiredParamPressed, {
  void Function()? onNullablePressed,
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  void Function(int)? onNullableParamPressed,
  // expect_lint: defined_value_changed_type, defined_value_setter_type
  void Function(int value)? onNullableNamedParamPressed,
  int Function()? onNotVoidPressed,
}) {}
