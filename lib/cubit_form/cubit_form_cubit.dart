import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'field_model.dart';

part 'cubit_form_state.dart';

InitialCubitFormState getInitialState(List<OldCubitFormField> fields) {
  var values = <String, dynamic>{};
  for (var f in fields) {
    values[f.id] = f.initialValue;
  }

  return InitialCubitFormState(values: values);
}

Map<String, List<ValidationModel>> getFormSchema(
    List<OldCubitFormField> fields) {
  var validationSchema = <String, List<ValidationModel>>{};
  for (var f in fields) {
    validationSchema[f.id] = f.validations;
  }

  return validationSchema;
}

class CubitFormCubit extends Cubit<CubitFormState> {
  CubitFormCubit(
    List<OldCubitFormField> fields, {
    isCheckingOn = false,
    @required this.onSubmit,
  })  : _isCheckingOn = isCheckingOn,
        _initIsCheckingOn = isCheckingOn,
        initialState = getInitialState(fields),
        validationSchema = getFormSchema(fields),
        super(getInitialState(fields));

  final InitialCubitFormState initialState;
  final Map<String, List<ValidationModel>> validationSchema;
  bool _isCheckingOn;
  bool _initIsCheckingOn;
  final FutureOr<void> Function(Map<String, dynamic> values) onSubmit;

  void reset() {
    _isCheckingOn = _initIsCheckingOn;
    emit(initialState);
  }

  void changeValue(fieldName, value) {
    var validators = validationSchema[fieldName];

    if (_isCheckingOn) {
      var error = _tillfirstError(value, validators);

      var errors = Map<String, String>.from(state.errors)
        ..addAll({fieldName: error});
      var values = Map<String, dynamic>.from(state.values)
        ..addAll({fieldName: value});

      emit(CubitFormState(
        values: values,
        errors: errors,
      ));
    } else {
      var values = Map<String, dynamic>.from(state.values)
        ..addAll({fieldName: value});

      emit(CubitFormState(
        values: values,
        errors: state.errors,
      ));
    }
  }

  _tillfirstError(value, List<ValidationModel> validators) {
    // maping validations till the end or the first error

    String error;
    for (var validation in validators) {
      error = validation.check(value);
      if (error != null) {
        break;
      }
    }
    return error;
  }

  void trySubmit() async {
    _isCheckingOn = true;

    var errors = <String, String>{};

    validationSchema.forEach((key, validators) {
      errors[key] = _tillfirstError(state.values[key], validators);
    });

    var hasErrors = !errors.values.every((el) => el == null);
    if (hasErrors) {
      emit(CubitFormState(
        values: state.values,
        errors: errors,
      ));
    } else {
      emit(CubitFormState(
        isSubmiting: true,
        values: state.values,
        errors: errors,
      ));
      await onSubmit(state.values);
      emit(CubitFormState(
        isSubmiting: false,
        values: state.values,
        errors: errors,
        hasSubmitted: true,
      ));
    }
  }
}
