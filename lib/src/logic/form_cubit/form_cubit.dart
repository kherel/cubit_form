import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cubit_form/cubit_form.dart';
import 'package:equatable/equatable.dart';

part 'form_cubit_state.dart';

abstract class FormCubit extends Cubit<FormCubitState> {
  FormCubit() : super(_initState);

  static FormCubitState _initState = FormCubitState(
    isErrorShown: false,
    isFormDataValid: false,
    isSubmitted: false,
    isSubmitting: false,
  );

  void reset() {
    for (var f in fields) {
      f.reset();
    }
  }

  final List<FieldCubit> fields = [];

  Future<void> close() async {
    for (var f in fields) {
      f.close();
    }
    await super.close();
  }

  @Deprecated('Use addFields instead.')
  void setFields(List<FieldCubit> fields) {
    addFields(fields);
  }

  void addFields(List<FieldCubit> newFields) {
    this.fields.addAll(newFields);
    for (var c in newFields) {
      c.stream.listen((state) {
        validateForm();
      });
    }
    validateForm();
  }

  void validateForm() {
    var isFormValid = fields.every((field) => field.state.isValid);
    if (isFormValid != state.isFormDataValid) {
      emit(state.copyWith(isFormValid: isFormValid));
    }
  }

  void setErrorShown() {
    emit(state.copyWith(isErrorShown: true));
  }

  FutureOr<void> onSubmit();

  FutureOr<bool> asyncValidation() => true;

  void trySubmit() async {
    if (state.isFormDataValid) {
      emit(state.copyWith(isSubmitting: true));

      var asyncValid = await asyncValidation();
      if (asyncValid) {
        await onSubmit();
        emit(state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          isErrorShown: false,
        ));
      } else {
        setShowErrorOnAllFields();
        emit(state.copyWith(
          isSubmitting: false,
          isErrorShown: true,
          isFormValid: false,
        ));
      }
    } else {
      setShowErrorOnAllFields();
      emit(state.copyWith(isErrorShown: true));
    }
  }

  void setShowErrorOnAllFields() {
    for (var f in fields) {
      f.showError();
    }
  }
}
