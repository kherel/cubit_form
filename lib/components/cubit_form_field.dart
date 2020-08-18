import 'package:cubit_form/logic/field_cubit/field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef FieldBuilder<T> = Widget Function(BuildContext context,
    {T initalValue, String error, OnChange<T> onChange});

typedef OnChange<T> = void Function(T value);

class CubitFormFieldWidget<T> extends StatefulWidget {
  const CubitFormFieldWidget({
    Key key,
    @required this.formFieldCubit,
    @required this.builder,
  }) : super(key: key);

  final FieldCubit formFieldCubit;
  final FieldBuilder<T> builder;

  @override
  _CubitFormFieldWidgetState<T> createState() =>
      _CubitFormFieldWidgetState<T>();
}

class _CubitFormFieldWidgetState<T> extends State<CubitFormFieldWidget<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fieldCubit = widget.formFieldCubit;

    return BlocBuilder<FieldCubit, FieldCubitState>(
      cubit: fieldCubit,
      buildWhen: (previous, current) {
        return previous.shownError != current.shownError;
      },
      builder: (context, state) {
        return widget.builder(
          context,
          initalValue: fieldCubit.initalValue,
          error: fieldCubit.state.shownError,
          onChange: fieldCubit.setValue,
        );
      },
    );
  }
}
