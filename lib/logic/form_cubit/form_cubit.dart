import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cubit_form/logic/field_cubit/field_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'form_cubit_state.dart';

abstract class FormCubit extends Cubit<FormCubitState> {
  FormCubit()
      : super(FormCubitState(
          isErrorShown: false,
          isFormValid: false,
          isSubmitted: false,
          isSubmitting: false,
        ));

  List<FieldCubit> fields;

  void setFields(List<FieldCubit> fields) {
    this.fields = fields;
    print(fields);
    for (var c in fields) {
      c.listen((state) {
        validateForm();
      });
    }
    validateForm();
  }

  void validateForm() {
    var isFormValid = fields.every((field) => field.state.isValid);
    if (isFormValid != state.isFormValid) {
      emit(state.copyWith(isFormValid: isFormValid));
    }
  }

  void setErrorShown() {
    emit(state.copyWith(isErrorShown: true));
  }

  FutureOr<void> onSubmit();

  void trySubmit() async {
    if (state.isFormValid) {
      emit(state.copyWith(isSubmitting: true));
      await onSubmit();
      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    }

    setShowErrorOnAllFields();
  }

  void setShowErrorOnAllFields() {
    for (var f in fields) {
      f.showError();
    }
  }
}
