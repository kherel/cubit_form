import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CubitFormTextField extends StatefulWidget {
  const CubitFormTextField({
    required this.formFieldCubit,
    this.maskController,
    this.keyboardType,
    this.decoration,
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  final FieldCubit<String> formFieldCubit;
  final InputDecoration? decoration;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final int maxLines;
  final MaskedTextController? maskController;
  @override
  CubitFormTextFieldState createState() => CubitFormTextFieldState();
}

class CubitFormTextFieldState extends State<CubitFormTextField> {
  TextEditingController controller = TextEditingController();

  late StreamSubscription subscription;
  @override
  void initState() {
    if (widget.maskController == null) {
      controller =
          TextEditingController(text: widget.formFieldCubit.state.value)
            ..addListener(() {
              widget.formFieldCubit.setValue(controller.text);
            });
    } else {
      widget.maskController!.addListener(() {
        widget.formFieldCubit.setMaskValue(widget.maskController!.text);
      });
    }

    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
    if (state is MaskFieldCubitState) {
      widget.maskController!.text = state.value;
      widget.maskController!.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.maskController!.text.length));
    }

    if (state is InitialFieldCubitState) {
      controller.clear();
      controller.text = state.value;
      _unfocus();
    }
    if (state is ExternalChangeFieldCubitState) {
      _unfocus();

      controller.text = state.value;
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  void _unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
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
        bloc: widget.formFieldCubit,
        builder: (context, state) {
          return TextField(
            maxLines: widget.maxLines,
            cursorColor: widget.cursorColor,
            focusNode: widget.focusNode,
            textAlign: widget.textAlign ?? TextAlign.left,
            style: widget.style ?? Theme.of(context).textTheme.subtitle1,
            keyboardType: widget.keyboardType,
            controller: widget.maskController ?? controller,
            obscureText: widget.obscureText,
            decoration: widget.decoration?.copyWith(
              errorText: state.isErrorShown ? state.error : null,
            ),
            inputFormatters: widget.inputFormatters,
            scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
          );
        });
  }
}
