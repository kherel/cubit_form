import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';

part 'multi_page_state.dart';

abstract class MultiPageFormCubit extends FormCubit<MultiPageFormState> {
  MultiPageFormCubit({
    bool isProtected = true,
    required int pageCount,
  }) : super(
          MultiPageFormState.initial(pageCount),
          isProtected: isProtected,
        );

  @override
  void reset() {
    for (var f in flatFields) {
      f.reset();
    }
  }

  final List<List<FieldCubit>> fields = [];

  List<FieldCubit> get flatFields =>
      fields.expand((element) => element).toList();

  @override
  Future<void> close() async {
    for (var f in flatFields) {
      f.close();
    }
    await super.close();
  }

  void setFields(List<List<FieldCubit>> fields) {
    this.fields.addAll(fields);

    for (var pageFields in fields) {
      final index = fields.indexOf(pageFields);
      for (var c in pageFields) {
        c.stream.listen((state) {
          if (!state.skipValidation) {
            validatePage(index);
          }
        });
      }
    }
    validateAllPages();
  }

  void validatePage(int pageIndex) {
    var isPageInitial = flatFields.every((field) => field.state.isInitial);

    final pageFields = fields[pageIndex];
    var isPageValid = pageFields.every((field) => field.state.isValid);

    if (isPageInitial != state.isInitial ||
        isPageValid != state.isFormDataValidPerPage(pageIndex)) {
      final isInitial = flatFields.every((field) => field.state.isInitial);

      final isFormValid = pageFields.every((field) => field.state.isValid);

      final newIsFormDataValidList = [...state.pageValidityList];
      newIsFormDataValidList[pageIndex] = isFormValid;

      emit(state.copyWith(
        isInitial: isInitial,
        pageValidityList: newIsFormDataValidList,
      ));
    }
  }

  void validateAllPages() {
    for (var i = 0; i < fields.length; i++) {
      validatePage(i);
    }
  }

  @override
  FutureOr<void> onSubmit();

  FutureOr<bool> asyncValidation() => true;

  FutureOr<void> tryToNextPage(int pageIndex, VoidCallback onSuccess) {
    if (state.pageValidityList[pageIndex]) {
      onSuccess();
    } else {
      setShowErrorOnPages([pageIndex]);
      setShowErrorOnPagesFields([pageIndex]);
    }
  }

  void trySubmit() async {
    if (state.isAllValid) {
      emit(state.copyWith(isBusy: true));

      var asyncValid = await asyncValidation();
      if (asyncValid) {
        await onSubmit();

        final newErrorShownOnPagesList = List.generate(
          state.errorShownOnPagesList.length,
          (_) => false,
        );

        emit(state.copyWith(
          isBusy: false,
          isSubmitted: true,
          errorShownOnPagesList: newErrorShownOnPagesList,
        ));
      } else {
        final invalidFieldsOnPages = getInvalidFieldsOnPages(fields);
        final pageIndexesList = getPageIndexesList(invalidFieldsOnPages);

        setShowErrorOnPages(pageIndexesList);
        setShowErrorOnPagesFields(pageIndexesList);

        emit(state.copyWith(
          isBusy: false,
          errorShownOnPagesList: invalidFieldsOnPages,
          pageValidityList: invalidFieldsOnPages,
        ));
      }
    } else {
      final invalidFieldsOnPages = getInvalidFieldsOnPages(fields);

      final pageIndexesList = getPageIndexesList(invalidFieldsOnPages);

      setShowErrorOnPages(pageIndexesList);
      setShowErrorOnPagesFields(pageIndexesList);

      emit(state.copyWith(
        errorShownOnPagesList: invalidFieldsOnPages,
        pageValidityList: invalidFieldsOnPages,
      ));
    }
  }

  void setShowErrorOnPagesFields(List<int> pageIndexes) {
    for (var pageIndex in pageIndexes) {
      for (var field in fields[pageIndex]) {
        field.showError();
      }
    }
  }

  void setShowErrorOnPages(List<int> pageIndexes) {
    final newErrorShownOnPagesList = [...state.errorShownOnPagesList];

    for (var pageIndex in pageIndexes) {
      newErrorShownOnPagesList[pageIndex] = true;
    }
    emit(state.copyWith(errorShownOnPagesList: newErrorShownOnPagesList));
  }
}

List<bool> getInvalidFieldsOnPages(List<List<FieldCubit>> pagesFields) {
  return pagesFields.map((listOfFields) {
    return listOfFields.any((field) => !field.state.isValid);
  }).toList();
}

List<int> getPageIndexesList(List<bool> invalidFieldsOnPages) {
  final pageIndexesList = <int>[];
  for (var i = 0; i < invalidFieldsOnPages.length; i++) {
    if (invalidFieldsOnPages[i]) {
      pageIndexesList.add(i);
    }
  }
  return pageIndexesList;
}
