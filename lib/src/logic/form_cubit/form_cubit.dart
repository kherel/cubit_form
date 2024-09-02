import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../cubit_form.dart';

part 'form_cubit_state.dart';

abstract class FormCubit<T extends FormCubitState> extends Cubit<T> {
  FormCubit(super.initialState, {required this.isProtected});

  void reset();

  Future<void> close();

  FutureOr<void> onSubmit();

  final bool isProtected;

  @override
  emit(T state) {
    if (isClosed && isProtected) {
      debugPrint('state emitted after close');
      debugPrint(state.toString());
      return;
    }

    super.emit(state);
  }
}
