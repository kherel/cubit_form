import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CubitFormTextField extends StatelessWidget {
  const CubitFormTextField({
    Key key,
    @required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
  }) : super(key: key);

  final FieldCubit formFieldCubit;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    return CubitFormFieldWidget<String>(
      formFieldCubit: formFieldCubit,
      builder: (context, {initalValue, error, onChange}) {
        return _TextFieldWithInitValue(
          initalValue,
          onChange,
          inputDecoration: decoration.copyWith(errorText: error),
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          scrollPadding: scrollPadding,
        );
      },
    );
  }
}

class _TextFieldWithInitValue extends StatefulWidget {
  const _TextFieldWithInitValue(
    this.initalValue,
    this.onChange, {
    this.inputDecoration,
    this.obscureText,
    this.keyboardType,
    this.inputFormatters,
    this.scrollPadding,
    Key key,
  }) : super(key: key);

  final String initalValue;
  final InputDecoration inputDecoration;
  final ValueChanged<String> onChange;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsets scrollPadding;

  @override
  _TextFieldWithInitValueState createState() => _TextFieldWithInitValueState();
}

class _TextFieldWithInitValueState extends State<_TextFieldWithInitValue> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController(text: widget.initalValue)
      ..addListener(() {
        widget.onChange(controller.text);
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      controller: controller,
      obscureText: widget.obscureText,
      decoration: widget.inputDecoration,
      inputFormatters: widget.inputFormatters,
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
    );
  }
}
