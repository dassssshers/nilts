enum Hoge { a, b, c }

// expect_lint: unstable_enum_values
const errorValues = Hoge.values;

enum Fuga {
  a,
  b,
  c;

  static List<Fuga> get staticValues => [Fuga.a, Fuga.b, Fuga.c];
}

final errorValues2 = Fuga.staticValues;

enum _Hoo { a, b, c }

const errorValues3 = _Hoo.values;
