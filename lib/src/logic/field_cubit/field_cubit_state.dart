part of 'field_cubit.dart';

class FieldCubitState<T> extends Equatable {
  const FieldCubitState({
    required this.value,
    required this.error,
    required this.isErrorShown,
  });

  final T value;
  final String? error;
  final bool isErrorShown;

  bool get isValid => error == null;
  String? get shownError => isErrorShown ? error : null;

  FieldCubitState<T> copyWith({
    T? value,
    String? error,
    bool? isErrorShown,
  }) {
    return FieldCubitState(
      error: error,
      value: value ?? this.value,
      isErrorShown: isErrorShown ?? this.isErrorShown,
    );
  }

  FieldCubitState<T> errorCheck({String? error}) {
    return FieldCubitErrorCheckState(
      value: value,
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
      error: error,
      value: value,
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
  const InitialFieldCubitState({required T initalValue, String? error})
      : super(value: initalValue, error: error, isErrorShown: false);

  @override
  List<Object?> get props => [value, error, isErrorShown];
}

class ExternalChangeFieldCubitState<T> extends FieldCubitState<T> {
  const ExternalChangeFieldCubitState({
    required T value,
    String? error,
    required bool isErrorShown,
  }) : super(
          value: value,
          error: error,
          isErrorShown: isErrorShown,
        );

  @override
  List<Object?> get props => [value, error, isErrorShown];
}

class FieldCubitErrorCheckState<T> extends FieldCubitState<T> {
  FieldCubitErrorCheckState({
    required T value,
    required String? error,
    required bool isErrorShown,
  }) : super(value: value, error: error, isErrorShown: isErrorShown);

  @override
  List<Object?> get props => [value, error, isErrorShown];
}
