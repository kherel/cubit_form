import 'package:cubit_form/cubit_form/cubit_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef FieldBuilder<T> = Widget Function(BuildContext context,
    {T initalValue, String error, OnChange<T> onChange});

typedef OnChange<T> = void Function(T value);

class CubitFormFieldWidget<T> extends StatefulWidget {
  const CubitFormFieldWidget({
    Key key,
    @required this.formFieldName,
    @required this.builder,
  }) : super(key: key);

  final String formFieldName;
  final FieldBuilder<T> builder;

  @override
  _CubitFormFieldWidgetState<T> createState() => _CubitFormFieldWidgetState<T>();
}

class _CubitFormFieldWidgetState<T> extends State<CubitFormFieldWidget<T>> {
  CubitFormCubit formCubit;

  @override
  void initState() {
    formCubit = BlocProvider.of<CubitFormCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var initialFieldValue = formCubit.initialState.values[widget.formFieldName];
    OnChange onChange = (value) => formCubit.changeValue(
          widget.formFieldName,
          value,
        );

    return BlocBuilder<CubitFormCubit, CubitFormState>(
      buildWhen: (previous, current) {
        var fieldName = widget.formFieldName;
        return previous.errors[fieldName] != current.errors[fieldName];
      },
      builder: (context, state) {
        return widget.builder(
          context,
          initalValue: initialFieldValue,
          error: formCubit.state.errors[widget.formFieldName],
          onChange: onChange,
        );
      },
    );
  }
}
