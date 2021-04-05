import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

export 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CubitFormMaskedTextField extends StatefulWidget {
  const CubitFormMaskedTextField({
    required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    required this.maskFormatter,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    Key? key,
  }) : super(key: key);

  final FieldCubit<String> formFieldCubit;

  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final MaskTextInputFormatter maskFormatter;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;

  @override
  CubitFormMaskedTextFieldState createState() =>
      CubitFormMaskedTextFieldState();
}

class CubitFormMaskedTextFieldState extends State<CubitFormMaskedTextField> {
  StreamSubscription? subscription;

  @override
  void initState() {
    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
    if (state is InitialFieldCubitState) {
      widget.maskFormatter.clear();
      widget.maskFormatter.formatEditUpdate(
        const TextEditingValue(),
        TextEditingValue(
          text: widget.formFieldCubit.state.value,
        ),
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CubitFormTextField(
      cursorColor: widget.cursorColor,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign ?? TextAlign.left,
      style: widget.style ?? Theme.of(context).textTheme.subtitle1,
      formFieldCubit: widget.formFieldCubit,
      keyboardType: widget.keyboardType,
      decoration: widget.decoration,
      inputFormatters: [widget.maskFormatter],
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
    );
  }
}
