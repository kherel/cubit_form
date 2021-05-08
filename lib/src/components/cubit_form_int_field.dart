import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CubitFormIntField extends StatefulWidget {
  const CubitFormIntField({
    required this.formFieldCubit,
    this.decoration,
    this.obscureText = false,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  final FieldCubit<int> formFieldCubit;
  final InputDecoration? decoration;
  final bool obscureText;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final int maxLines;

  @override
  CubitFormIntFieldState createState() => CubitFormIntFieldState();
}

class CubitFormIntFieldState extends State<CubitFormIntField> {
  TextEditingController controller = TextEditingController();

  late StreamSubscription subscription;
  @override
  void initState() {
    controller = TextEditingController(
        text: widget.formFieldCubit.state.value.toString())
      ..addListener(() {
        widget.formFieldCubit.setValue(int.parse(controller.text));
      });
    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<int> state) {
    if (state is InitialFieldCubitState) {
      controller.clear();
      controller.text = state.value.toString();
      _unfocus();
    }
    if (state is ExternalChangeFieldCubitState) {
      _unfocus();

      controller.text = state.value.toString();
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
            keyboardType: TextInputType.number,
            controller: controller,
            obscureText: widget.obscureText,
            decoration: widget.decoration?.copyWith(
              errorText: state.isErrorShown ? state.error : null,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
          );
        });
  }
}
