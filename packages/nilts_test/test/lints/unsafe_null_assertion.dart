const String? nullableString = null;
const String nonNullableString = 'nonNullableString';

void main() {
  // expect_lint: unsafe_null_assertion
  nullableString!.length;

  (nullableString ?? '').length;
  nonNullableString.length;
  nullableString?.length;
}

int length(String? string) {
  if (string case final value?) return value.length;
  return 0;
}
