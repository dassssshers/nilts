import 'package:analyzer/src/lint/registry.dart';
import 'package:analyzer/utilities/package_config_file_builder.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:nilts_clock/src/lints/using_date_time_now.dart';
import 'package:test/test.dart';

// Note: We cannot use test_reflective_loader in this test because:
// 1. test_reflective_loader depends on dart:mirrors
// 2. dart:mirrors is not supported in the Flutter test runner
// 3. This package is part of a Flutter workspace and must use `flutter test`
// Therefore, we use the standard `test` package with group() and test().
void main() {
  group('UsingDateTimeNow', () {
    late UsingDateTimeNowTest testInstance;

    setUp(() {
      testInstance = UsingDateTimeNowTest()..setUp();
    });

    test('using date time now', () async {
      await testInstance.assertDiagnostics(
        '''
final dateTimeNow = DateTime.now();
''',
        [testInstance.lint(20, 14)],
      );
    });

    test('not using DateTime.now()', () async {
      await testInstance.assertNoDiagnostics('''
void foo() {
  print('hello');
}
''');
    });

    test('using clock.now() should not trigger lint', () async {
      await testInstance.assertNoDiagnostics('''
import 'package:clock/clock.dart';

final DateTime clockNow = clock.now();
''');
    });

    test(
      'using DateTime constructors other than now() should not trigger lint',
      () async {
        await testInstance.assertNoDiagnostics('''
final dateTimeTimestamp = DateTime.timestamp();
final dateTime = DateTime(2025);
final dateTimeUtc = DateTime.utc(2025);
''');
      },
    );
  });
}

class UsingDateTimeNowTest extends AnalysisRuleTest {
  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UsingDateTimeNow());
    super.setUp();

    // After super.setUp() calls createMockSdk,
    // replace the DateTime definition in /sdk/lib/core/core.dart with an extended version.
    // The default mock_sdk only includes DateTime.now(), so we add:
    // - DateTime.timestamp()
    // - DateTime() (default constructor)
    // - DateTime.utc()
    final coreFile = getFile('/sdk/lib/core/core.dart');
    var coreContent = coreFile.readAsStringSync();

    // Find and replace the existing DateTime class definition
    const extendedDateTime = '''
class DateTime implements Comparable<DateTime> {
  external DateTime._now();
  DateTime.now() : this._now();

  external DateTime._timestamp();
  DateTime.timestamp() : this._timestamp();

  external DateTime._(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond);
  DateTime(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0])
    : this._(year, month, day, hour, minute, second, millisecond, microsecond);

  external DateTime._utc(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond);
  DateTime.utc(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0])
    : this._utc(year, month, day, hour, minute, second, millisecond, microsecond);

  external int compareTo(DateTime other);
  external bool isBefore(DateTime other);
  external int get millisecondsSinceEpoch;
}''';

    // Replace the existing DateTime class definition using regex
    coreContent = coreContent.replaceFirst(
      RegExp(
        r'class DateTime implements Comparable<DateTime> \{[^}]*\}',
        multiLine: true,
        dotAll: true,
      ),
      extendedDateTime,
    );

    // Overwrite the file with the extended version
    coreFile.writeAsStringSync(coreContent);

    // Create a mock clock package
    newFile('/clock/lib/clock.dart', '''
class Clock {
  DateTime now() => DateTime.now();
}

final clock = Clock();
''');

    writeTestPackageConfig(
      PackageConfigFileBuilder()..add(name: 'clock', rootPath: '/clock'),
    );
  }

  @override
  String get analysisRule => UsingDateTimeNow.ruleName;
}
