enum Hoge { a, b, c }

// expect_lint: unstable_enum_values
const List<Hoge> errorValues = Hoge.values;

enum Fuga {
  a,
  b,
  c
  ;

  static List<Fuga> get staticValues => [Fuga.a, Fuga.b, Fuga.c];
}

final List<Fuga> errorValues2 = Fuga.staticValues;

enum _Hoo { a, b, c }

// This is a test case for private enum.
// ignore: unused_element
const List<_Hoo> _errorValues3 = _Hoo.values;
