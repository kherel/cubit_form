part of 'form_field_cubit.dart';

class FormFieldState<T> extends Equatable {
  const FormFieldState({
    this.value,
    this.error,
    this.isErrorShown = false,
  });

  final T value;
  final String error;
  final bool isErrorShown;

  bool get isValid => error == null;
  String get shownError => isErrorShown ? error : null;

  @override
  List<Object> get props => [value, error, isErrorShown];

  FormFieldState<T> copyWith({
    T value,
    @required String error,
    bool isErrorShown,
  }) {
    return FormFieldState(
      error: error,
      value: value ?? this.value,
      isErrorShown: isErrorShown ?? this.isErrorShown,
    );
  }

  @override
  String toString() {
    return 'value: $value, error: $error, isErrorShown: $isErrorShown';
  }
}
