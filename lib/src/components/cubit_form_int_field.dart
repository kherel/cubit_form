import 'dart:async';
import 'dart:math' as math;

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CubitFormIntField extends StatefulWidget {
  const CubitFormIntField({
    required this.formFieldCubit,
    this.decoration = const InputDecoration(),
    this.obscureText = false,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.maxLines = 1,
    this.autofocus = false,
    Key? key,
    this.prefixText,
    this.hintText,
    this.onEditingComplete,
  }) : super(key: key);

  final FieldCubit<int> formFieldCubit;
  final String? prefixText;
  final String? hintText;
  final InputDecoration decoration;
  final bool obscureText;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
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
        widget.formFieldCubit.setValue(
            controller.text.isNotEmpty ? int.parse(controller.text) : 0);
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
            onEditingComplete: widget.onEditingComplete,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            cursorColor: widget.cursorColor,
            focusNode: widget.focusNode,
            textAlign: widget.textAlign ?? TextAlign.left,
            style: widget.style ?? Theme.of(context).textTheme.titleMedium,
            keyboardType: TextInputType.number,
            controller: controller,
            obscureText: widget.obscureText,
            onChanged: (value) {
              var selection = controller.selection;
              final RegExp regexp = new RegExp(r'^0+(?=.)');
              var match = regexp.firstMatch(value);

              var matchLengh = match?.group(0)?.length ?? 0;
              if (matchLengh != 0) {
                controller.text = value.replaceAll(regexp, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: math.min(matchLengh, selection.extent.offset),
                  ),
                );
              }
            },
            decoration: widget.decoration.copyWith(
              prefixStyle:
                  widget.style ?? Theme.of(context).textTheme.titleMedium,
              prefixText: widget.prefixText,
              hintText: widget.hintText,
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
