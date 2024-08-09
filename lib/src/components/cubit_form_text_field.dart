import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CubitFormTextField extends StatefulWidget {
  const CubitFormTextField({
    required this.formFieldCubit,
    this.keyboardType,
    this.decoration = const InputDecoration(),
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.maxLines = 1,
    this.autofocus = false,
    super.key,
    this.prefixText,
    this.hintText,
    this.isDisabled = false,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
  });

  final FieldCubit<String> formFieldCubit;
  final String? prefixText;
  final String? hintText;
  final InputDecoration decoration;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final int maxLines;
  final bool isDisabled;
  final VoidCallback? onEditingComplete;
  final TextInputAction textInputAction;

  @override
  CubitFormTextFieldState createState() => CubitFormTextFieldState();
}

class CubitFormTextFieldState extends State<CubitFormTextField> {
  TextEditingController controller = TextEditingController();

  late StreamSubscription subscription;
  @override
  void initState() {
    controller = TextEditingController(text: widget.formFieldCubit.state.value)
      ..addListener(() {
        widget.formFieldCubit.setValue(controller.text);
      });
    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<String> state) {
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
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onEditingComplete: widget.onEditingComplete,
            autofocus: widget.autofocus,
            enabled: !widget.isDisabled,
            maxLines: widget.maxLines,
            cursorColor: widget.cursorColor,
            focusNode: widget.focusNode,
            textAlign: widget.textAlign ?? TextAlign.left,
            style: widget.style ?? Theme.of(context).textTheme.titleMedium,
            keyboardType: widget.keyboardType,
            controller: controller,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            decoration: widget.decoration.copyWith(
              prefixStyle:
                  widget.style ?? Theme.of(context).textTheme.titleMedium,
              prefixText: widget.prefixText,
              hintText: widget.hintText,
            ),
            inputFormatters: widget.inputFormatters,
            scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
          );
        });
  }
}
