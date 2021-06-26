part of 'field_cubit.dart';

class FieldCubitState<T> extends Equatable {
  const FieldCubitState({
    required this.value,
    required this.error,
    required this.isErrorShown,
    required this.initialValue,
  });

  final T value;
  final T initialValue;

  final String? error;
  final bool isErrorShown;

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
    String? error,
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
  }) {
    return FieldCubitState(
      error: error,
      value: value ?? this.value,
      isErrorShown: isErrorShown ?? this.isErrorShown,
      initialValue: initialValue,
    );
  }

  FieldCubitState<T> errorCheck({String? error}) {
    return FieldCubitErrorCheckState(
      value: value,
      initalValue: initialValue,
      error: error,
      isErrorShown: isErrorShown,
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

  FieldCubitState<T> setMaskValue({
    required T value,
    required String? error,
    bool? isErrorShown,
  }) {
    return MaskFieldCubitState(
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
  List<Object?> get props => [value, error, isErrorShown];
}

class MaskFieldCubitState<T> extends FieldCubitState<T> {
  const MaskFieldCubitState({
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
  List<Object?> get props => [value, error, isErrorShown];
}

class FieldCubitErrorCheckState<T> extends FieldCubitState<T> {
  FieldCubitErrorCheckState({
    required T value,
    required T initalValue,
    required String? error,
    required bool isErrorShown,
  }) : super(
          value: value,
          initialValue: initalValue,
          error: error,
          isErrorShown: isErrorShown,
        );

  @override
  List<Object?> get props => [value, initialValue, error, isErrorShown];
}
