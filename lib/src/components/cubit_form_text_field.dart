import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CubitFormTextField extends StatefulWidget {
  const CubitFormTextField({
    @required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    Key key,
  }) : super(key: key);

  final FieldCubit<String> formFieldCubit;
  final InputDecoration decoration;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsets scrollPadding;
  final TextStyle style;
  final TextAlign textAlign;
  final FocusNode focusNode;

  @override
  CubitFormTextFieldState createState() => CubitFormTextFieldState();
}

class CubitFormTextFieldState extends State<CubitFormTextField> {
  TextEditingController controller = TextEditingController();

  StreamSubscription subscription;
  @override
  void initState() {
    controller = TextEditingController(text: widget.formFieldCubit.state.value)
      ..addListener(() {
        if (widget.formFieldCubit.state is! ExternalChangeFieldCubitState) {
          widget.formFieldCubit.setValue(controller.text);
        }
      });
    subscription = widget.formFieldCubit.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
    if (state is InitialFieldCubitState) {
      controller.clear();
    }
    if (state is ExternalChangeFieldCubitState) {
      controller.text = state.value;
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCubit, FieldCubitState>(
        cubit: widget.formFieldCubit,
        builder: (context, state) {
          return TextField(
            focusNode: widget.focusNode,
            textAlign: widget.textAlign ?? TextAlign.left,
            style: widget.style ?? Theme.of(context).textTheme.subtitle1,
            keyboardType: widget.keyboardType,
            controller: controller,
            obscureText: widget.obscureText,
            decoration: widget.decoration.copyWith(
              errorText: state.isErrorShown ? state.error : null,
            ),
            inputFormatters: widget.inputFormatters,
            scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
          );
        });
  }
}
