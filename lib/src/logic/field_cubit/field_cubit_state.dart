part of 'field_cubit.dart';

class FieldCubitState<T> extends Equatable {
  const FieldCubitState({
    required this.value,
    required this.error,
    required this.isErrorShown,
    required this.initialValue,
    this.skipValidation = false,
  });

  final T value;
  final T initialValue;

  final String? error;
  final bool isErrorShown;
  final bool skipValidation;

  bool get isValid => error == null;

  bool get isInitial {
    if (initialValue is List) {
      return deepEq(initialValue, value);
    }
    return value == initialValue;
  }

  String? get shownError => isErrorShown ? error : null;

  FieldCubitState<T> setValue({
    required T value,
    required String? error,
  }) {
    return FieldCubitState(
      error: error,
      value: value,
      isErrorShown: isErrorShown,
      initialValue: initialValue,
    );
  }

  FieldCubitState<T> copyWith({
    T? value,
    String? error,
    bool? isErrorShown,
    bool? skipValidation,
  }) {
    return FieldCubitState(
      error: error,
      value: value ?? this.value,
      isErrorShown: isErrorShown ?? this.isErrorShown,
      skipValidation: skipValidation ?? this.skipValidation,
      initialValue: initialValue,
    );
  }

  FieldCubitState<T> externalChange({
    required T value,
    required String? error,
    bool? isErrorShown,
  }) {
    return ExternalChangeFieldCubitState(
      value: value,
      initalValue: initialValue,
      error: error,
      isErrorShown: isErrorShown ?? this.isErrorShown,
    );
  }

  @override
  String toString() {
    return 'value: $value, error: $error, isErrorShown: $isErrorShown';
  }

  @override
  List<Object?> get props => [value, error, isErrorShown];
}

class InitialFieldCubitState<T> extends FieldCubitState<T> {
  const InitialFieldCubitState({
    required T initalValue,
    String? error,
  }) : super(
            value: initalValue,
            initialValue: initalValue,
            error: error,
            isErrorShown: false);

  @override
  List<Object?> get props => [value, initialValue, error, isErrorShown];
}

class ExternalChangeFieldCubitState<T> extends FieldCubitState<T> {
  const ExternalChangeFieldCubitState({
    required T value,
    required T initalValue,
    String? error,
    required bool isErrorShown,
  }) : super(
          value: value,
          initialValue: initalValue,
          error: error,
          isErrorShown: isErrorShown,
        );

  @override
  List<Object?> get props => [
        value,
        error,
        isErrorShown,
        initialValue,
      ];
}
