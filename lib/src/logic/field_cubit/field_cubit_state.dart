part of 'field_cubit.dart';

class FieldCubitState<T> {
  const FieldCubitState({
    @required this.value,
    @required this.error,
    @required this.isErrorShown,
  });

  final T value;
  final String error;
  final bool isErrorShown;

  bool get isValid => error == null;
  String get shownError => isErrorShown ? error : null;

  FieldCubitState<T> copyWith({
    T value,
    @required String error,
    bool isErrorShown,
  }) {
    return FieldCubitState(
      error: error,
      value: value ?? this.value,
      isErrorShown: isErrorShown ?? this.isErrorShown,
    );
  }

  FieldCubitState<T> externalChange({
    T value,
    @required String error,
    bool isErrorShown,
  }) {
    return ExternalChangeFieldCubitState(
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

class InitialFieldCubitState<T> extends FieldCubitState<T> {
  const InitialFieldCubitState({T initalValue, String error})
      : super(value: initalValue, error: error, isErrorShown: false);
}

class ExternalChangeFieldCubitState<T> extends FieldCubitState<T> {
  const ExternalChangeFieldCubitState({
    T value,
    String error,
    bool isErrorShown,
  }) : super(
          value: value,
          error: error,
          isErrorShown: isErrorShown,
        );
}
