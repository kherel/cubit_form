import 'package:bloc/bloc.dart';
import 'package:cubit_form/src/logic/models/validation.dart';
import 'package:equatable/equatable.dart';

part 'field_cubit_state.dart';

class FieldCubit<T> extends Cubit<FieldCubitState<T>> {
  FieldCubit({
    required this.initalValue,
    this.validations = const [],
  }) : super(FieldCubitState<T>(
          value: initalValue,
          error: tillfirstError<T>(initalValue, validations),
          isErrorShown: false,
        ));

  final T initalValue;
  final List<ValidationModel<T>> validations;

  void setValue(T value) {
    return emit(
      state.copyWith(
        value: value,
        error: tillfirstError<T>(value, validations),
      ),
    );
  }

  void externalSetValue(T value) {
    return emit(
      state.externalChange(
        value: value,
        error: tillfirstError<T>(value, validations),
      ),
    );
  }

  //for async validation
  void setError(String error) => emit(
        state.copyWith(
          error: error,
        ),
      );

  void errorCheck() => emit(
        state.errorCheck(
          error: tillfirstError<T>(state.value, validations),
        ),
      );

  void showError() => emit(
        state.copyWith(
          isErrorShown: true,
          error: state.error,
        ),
      );

  void reset() => emit(
        InitialFieldCubitState<T>(
          initalValue: initalValue,
          error: tillfirstError<T>(initalValue, validations),
        ),
      );
}

String? tillfirstError<T>(T value, validations) {
  String? error;
  for (var validation in validations) {
    error = validation.check(value);
    if (error != null) {
      break;
    }
  }
  return error;
}
