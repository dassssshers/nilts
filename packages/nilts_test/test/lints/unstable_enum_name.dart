enum Hoge {
  a,
  b,
  c
  ;

  String get id => switch (this) {
    a => 'a',
    b => 'b',
    c => 'c',
  };
}

// expect_lint: unstable_enum_name
final String name = Hoge.a.name;

final String id = Hoge.a.id;
