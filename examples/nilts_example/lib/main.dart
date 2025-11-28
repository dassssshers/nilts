// ignore_for_file: unused_local_variable, unreachable_from_main for testing

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MainApp());
}

// =============================================================================
// nilts_flutter_hooks/unnecessary_hook_widget
// - HookWidget that doesn't use any hooks
// =============================================================================
// ignore: nilts_flutter_hooks/unnecessary_hook_widget
final class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // nilts_clock/using_date_time_now
    // - Using DateTime.now() instead of clock.now()
    // =========================================================================
    // ignore: nilts_clock/using_date_time_now
    final now = DateTime.now();

    // =========================================================================
    // nilts/unsafe_null_assertion
    // - Using ! operator for null assertion
    // =========================================================================
    String? nullableString;
    // ignore: nilts/unsafe_null_assertion for testing
    final nonNullString = nullableString!;

    // =========================================================================
    // nilts/low_readability_numeric_literals
    // - Numeric literals with 5+ digits without separators
    // =========================================================================
    // ignore: nilts/low_readability_numeric_literals
    const largeNumber = 123456789;

    // =========================================================================
    // nilts/no_support_web_platform_check
    // - Using Platform.isXxx which doesn't support web
    // =========================================================================
    // ignore: nilts/no_support_web_platform_check
    final isAndroid = Platform.isAndroid;

    // =========================================================================
    // nilts/unnecessary_rebuilds_from_media_query
    // - Using MediaQuery.of(context) instead of specific getters
    // =========================================================================
    // ignore: nilts/unnecessary_rebuilds_from_media_query
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // =================================================================
            // nilts/fixed_text_scale_rich_text
            // - RichText without textScaler parameter
            // =================================================================
            // ignore: nilts/fixed_text_scale_rich_text
            RichText(
              text: const TextSpan(text: 'Hello'),
            ),

            // =================================================================
            // nilts/no_support_multi_text_direction
            // - Using non-directional alignment/padding classes
            // =================================================================
            const Align(
              // ignore: nilts/no_support_multi_text_direction for testing
              alignment: Alignment.bottomLeft,
              child: Text('Aligned'),
            ),

            const Padding(
              // ignore: nilts/no_support_multi_text_direction for testing
              padding: EdgeInsets.only(left: 8),
              child: Text('Padded'),
            ),

            // =================================================================
            // nilts/shrink_wrapped_scroll_view
            // - Using shrinkWrap: true in scroll views
            // =================================================================
            // ignore: nilts/shrink_wrapped_scroll_view
            ListView(
              shrinkWrap: true,
              children: const [Text('Item')],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// nilts/open_type_hierarchy
// - Class without explicit inheritance modifiers (final, sealed, base)
// =============================================================================
// ignore: nilts/open_type_hierarchy
class OpenClass {
  const OpenClass();
}

// =============================================================================
// nilts/defined_void_callback_type
// - Using void Function() instead of VoidCallback
// =============================================================================
// ignore: nilts/defined_void_callback_type
void acceptVoidCallback(void Function() callback) {}

// =============================================================================
// nilts/defined_async_callback_type
// - Using Future<void> Function() instead of AsyncCallback
// =============================================================================
// ignore: nilts/defined_async_callback_type
void acceptAsyncCallback(Future<void> Function() callback) {}

// =============================================================================
// nilts/defined_value_changed_type
// - Using void Function(T) instead of ValueChanged<T>
// =============================================================================
// ignore: nilts/defined_value_changed_type, nilts/defined_value_setter_type
void acceptValueChanged(void Function(String) callback) {}

// =============================================================================
// nilts/defined_value_setter_type
// - Using void Function(T) instead of ValueSetter<T>
// =============================================================================
// ignore: nilts/defined_value_setter_type, nilts/defined_value_changed_type
void acceptValueSetter(void Function(int) callback) {}

// =============================================================================
// nilts/defined_value_getter_type
// - Using T Function() instead of ValueGetter<T>
// =============================================================================
// ignore: nilts/defined_value_getter_type
void acceptValueGetter(String Function() callback) {}

// =============================================================================
// nilts/defined_async_value_getter_type
// - Using Future<T> Function() instead of AsyncValueGetter<T>
// =============================================================================
// ignore: nilts/defined_async_value_getter_type
void acceptAsyncValueGetter(Future<String> Function() callback) {}

// =============================================================================
// nilts/defined_async_value_setter_type
// - Using Future<void> Function(T) instead of AsyncValueSetter<T>
// =============================================================================
// ignore: nilts/defined_async_value_setter_type
void acceptAsyncValueSetter(Future<void> Function(String) callback) {}

// =============================================================================
// nilts/unstable_enum_name
// - Using .name property on enum values
// =============================================================================
enum SampleEnum { one, two, three }

String getEnumName(SampleEnum value) {
  // ignore: nilts/unstable_enum_name for testing
  return value.name;
}

// =============================================================================
// nilts/unstable_enum_values
// - Using .values property on enums
// =============================================================================
List<SampleEnum> getAllEnumValues() {
  // ignore: nilts/unstable_enum_values for testing
  return SampleEnum.values;
}
