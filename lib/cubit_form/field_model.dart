import 'package:meta/meta.dart';

class ValidationModel<T> {
  final String errorMassage;
  final bool Function(T) test;

  const ValidationModel(this.test, this.errorMassage);

  String check(T val) {
    return test(val) ? errorMassage : null;
  }
}

class OldCubitFormField<T> {
  const OldCubitFormField({
    @required this.id,
    @required this.initialValue,
    @required this.validations,
  });

  final String id;
  final T initialValue;
  final List<ValidationModel<T>> validations;
}
