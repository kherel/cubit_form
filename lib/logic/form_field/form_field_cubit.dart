import 'package:bloc/bloc.dart';
import 'package:cubit_form/cubit_form/field_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'form_field_state.dart';

class FormFieldCubit<T> extends Cubit<FormFieldState<T>> {
  FormFieldCubit({
    @required this.initalValue,
    this.validations = const [],
  }) : super(FormFieldState<T>(
          value: initalValue,
        ));

  final T initalValue;
  final List<ValidationModel<T>> validations;

  void setValue(T value) {
    var error = _tillfirstError(value);

    emit(
      state.copyWith(
        value: value,
        error: error,
      ),
    );
  }

  void showError() {
    emit(
      state.copyWith(
        isErrorShown: true,
        error: state.error,
      ),
    );
  }

  void reset() {
    emit(
      FormFieldState<T>(
        value: initalValue,
      ),
    );
  }

  String _tillfirstError(T value) {
    String error;
    for (var validation in validations) {
      error = validation.check(value);
      if (error != null) {
        break;
      }
    }
    return error;
  }
}
