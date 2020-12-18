import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskCubitTextField extends StatefulWidget {
  const MaskCubitTextField({
    @required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    this.obscureText = false,
    this.maskFormatter,
    this.scrollPadding,
    Key key,
  }) : super(key: key);

  final FieldCubit<String> formFieldCubit;

  final InputDecoration decoration;
  final bool obscureText;
  final TextInputType keyboardType;
  final MaskTextInputFormatter maskFormatter;
  final EdgeInsets scrollPadding;

  @override
  MaskCubitTextFieldState createState() => MaskCubitTextFieldState();
}

class MaskCubitTextFieldState extends State<MaskCubitTextField> {
  StreamSubscription subscription;

  @override
  void initState() {
    subscription = widget.formFieldCubit.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
    if (state is InitialFieldCubitState) {
      if (widget.maskFormatter != null) {
        widget.maskFormatter.clear();
      }
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CubitFormTextField(
      formFieldCubit: widget.formFieldCubit,
      keyboardType: widget.keyboardType,
      decoration: widget.decoration,
      obscureText: widget.obscureText,
      inputFormatters: [widget.maskFormatter],
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
    );
  }
}
