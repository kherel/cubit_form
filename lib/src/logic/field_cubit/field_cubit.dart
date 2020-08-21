import 'package:bloc/bloc.dart';
import 'package:cubit_form/src/logic/models/validadation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'field_cubit_state.dart';

class FieldCubit<T> extends Cubit<FieldCubitState<T>> {
  FieldCubit({
    @required this.initalValue,
    this.validations = const [],
  }) : super(FieldCubitState<T>(
          value: initalValue,
          error: tillfirstError<T>(initalValue, validations),
          isErrorShown: false,
        ));

  final T initalValue;
  final List<ValidationModel<T>> validations;

  void setValue(T value) {
    var error = tillfirstError<T>(value, validations);

    emit(
      state.copyWith(
        value: value,
        error: error,
      ),
    );
  }

  void errorCheck() {
    var error = tillfirstError<T>(state.value, validations);

    emit(state.copyWith(error: error));
  }

  void showError() {
    emit(
      state.copyWith(
        isErrorShown: true,
        error: state.error,
      )
    );
  }

  void reset() {
    emit(
      FieldCubitState<T>(
          value: initalValue, error: null, isErrorShown: false),
    );
  }
}

String tillfirstError<T>(T value, validations) {
  String error;
  for (var validation in validations) {
    error = validation.check(value);
    if (error != null) {
      break;
    }
  }
  return error;
}
