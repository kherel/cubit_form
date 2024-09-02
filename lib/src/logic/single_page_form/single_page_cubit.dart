import 'dart:async';

import '../../../cubit_form.dart';

part 'single_page_state.dart';

abstract class SinglePageFormCubit extends FormCubit<SinglePageFormState> {
  SinglePageFormCubit({
    bool isProtected = true,
  }) : super(
          _initState,
          isProtected: isProtected,
        );

  static SinglePageFormState _initState = SinglePageFormState(
    isInitial: true,
    isErrorShown: false,
    isFormDataValid: false,
    isSubmitted: false,
    isBusy: false,
  );

  @override
  void reset() {
    for (var f in fields) {
      f.reset();
    }
    emit(_initState);
  }

  final List<FieldCubit> fields = [];

  @override
  Future<void> close() async {
    for (var f in fields) {
      f.close();
    }
    await super.close();
  }

  void addFields(List<FieldCubit> newFields) {
    this.fields.addAll(newFields);
    for (var c in newFields) {
      c.stream.listen((state) {
        if (state.skipValidation) {
          validateForm();
        }
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

  @override
  FutureOr<void> onSubmit();

  FutureOr<bool> asyncValidation() => true;

  void trySubmit() async {
    if (state.isFormDataValid) {
      emit(state.copyWith(isBusy: true));

      var asyncValid = await asyncValidation();
      if (asyncValid) {
        await onSubmit();
        emit(state.copyWith(
          isBusy: false,
          isSubmitted: true,
          isErrorShown: false,
        ));
      } else {
        setShowErrorOnAllFields();
        emit(state.copyWith(
          isBusy: false,
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
