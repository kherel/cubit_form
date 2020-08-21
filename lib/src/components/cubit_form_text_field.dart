import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../cubit_form.dart';
import 'cubit_form_field.dart';

class CubitFormTextField extends StatelessWidget {
  const CubitFormTextField({
    Key key,
    @required this.formFieldCubit,
    this.hintText,
    this.labeText,
    this.obscureText = false,
  }) : super(key: key);

  final FieldCubit formFieldCubit;
  final String hintText;
  final String labeText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return CubitFormFieldWidget<String>(
      formFieldCubit: formFieldCubit,
      builder: (context, {initalValue, error, onChange}) {
        return _TextFieldWithInitValue(
          initalValue,
          error,
          onChange,
          hintText: hintText,
          obscureText: obscureText,
        );
      },
    );
  }
}

class _TextFieldWithInitValue extends StatefulWidget {
  const _TextFieldWithInitValue(
    this.initalValue,
    this.error,
    this.onChange, {
    this.hintText,
    this.labeText,
    this.obscureText,
    Key key,
  }) : super(key: key);

  final String initalValue;
  final String error;
  final String hintText;
  final OnChange<String> onChange;
  final String labeText;
  final bool obscureText;

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
      controller: controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.error,
        labelText: widget.labeText,
      ),
    );
  }
}
