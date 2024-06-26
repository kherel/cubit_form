import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../cubit_form.dart';

part 'form_cubit_state.dart';

abstract class FormCubit extends Cubit<FormCubitState> {
  FormCubit() : super(_initState);

  static FormCubitState _initState = FormCubitState(
    isInitial: true,
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
    var isInitial = fields.every((field) => field.state.isInitial);

    if (isFormValid != state.isFormDataValid || isInitial != state.isInitial) {
      emit(state.copyWith(
        isInitial: isInitial,
        isFormValid: isFormValid,
      ));
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
