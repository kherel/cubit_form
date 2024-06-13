import 'dart:async';

import 'package:cubit_form/src/logic/field_cubit/field_cubit.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'cubit_form_text_field.dart';

class CubitFormMaskedTextField extends StatefulWidget {
  const CubitFormMaskedTextField({
    required this.formFieldCubit,
    this.keyboardType,
    this.decoration = const InputDecoration(),
    required this.maskFormatter,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.autofocus = false,
    this.prefixText,
    this.hintText,
    this.onEditingComplete,
    Key? key,
  }) : super(key: key);

  final FieldCubit<String> formFieldCubit;
  final String? prefixText;
  final String? hintText;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final MaskTextInputFormatter maskFormatter;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final bool autofocus;
  final VoidCallback? onEditingComplete;

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
      onEditingComplete: widget.onEditingComplete,
      autofocus: widget.autofocus,
      cursorColor: widget.cursorColor,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign ?? TextAlign.left,
      style: widget.style ?? Theme.of(context).textTheme.titleMedium,
      formFieldCubit: widget.formFieldCubit,
      keyboardType: widget.keyboardType,
      decoration: widget.decoration,
      inputFormatters: [
        widget.maskFormatter,
      ],
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
    );
  }
}
