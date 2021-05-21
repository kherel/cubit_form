import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'cubit_form_text_field.dart';

export 'package:extended_masked_text/extended_masked_text.dart';

class CubitFormMaskedTextField extends StatefulWidget {
  const CubitFormMaskedTextField({
    required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    required this.mask,
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

  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final String mask;

  @override
  CubitFormMaskedTextFieldState createState() =>
      CubitFormMaskedTextFieldState();
}

class CubitFormMaskedTextFieldState extends State<CubitFormMaskedTextField> {
  StreamSubscription? subscription;

  late MaskedTextController maskController;

  @override
  void initState() {
    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    maskController = MaskedTextController(
      text: widget.formFieldCubit.state.value,
      mask: widget.mask,
    );
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
    if (state is InitialFieldCubitState) {
      maskController.clear();
      // widget.maskFormatter.formatEditUpdate(
      //   const TextEditingValue(),
      //   TextEditingValue(
      //     text: widget.formFieldCubit.state.value,
      //   ),
      // );
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
      maskController: maskController,
      cursorColor: widget.cursorColor,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign ?? TextAlign.left,
      style: widget.style ?? Theme.of(context).textTheme.subtitle1,
      formFieldCubit: widget.formFieldCubit,
      keyboardType: widget.keyboardType,
      decoration: widget.decoration,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
    );
  }
}
