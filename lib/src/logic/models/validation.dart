class ValidationModel<T> {
  final String errorMassage;
  final bool Function(T) test;

  const ValidationModel(this.test, this.errorMassage);

  String? check(T val) {
    return test(val) ? errorMassage : null;
  }
}
