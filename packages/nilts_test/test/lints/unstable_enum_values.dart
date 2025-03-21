enum Hoge { a, b, c }

// expect_lint: unstable_enum_values
const errorValues = Hoge.values;

enum _Fuga {
  a,
  b,
  c;

  static List<_Fuga> get staticValues => [_Fuga.a, _Fuga.b, _Fuga.c];
}

final errorValues2 = _Fuga.staticValues;
