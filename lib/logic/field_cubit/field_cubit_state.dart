part of 'field_cubit.dart';

class FieldCubitState<T> extends Equatable {
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

  @override
  List<Object> get props => [value, error, isErrorShown];

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

  @override
  String toString() {
    return 'value: $value, error: $error, isErrorShown: $isErrorShown';
  }
}
