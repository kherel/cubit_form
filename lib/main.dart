import 'package:cubit_form/cubit_form/cubit_form_cubit.dart';
import 'package:cubit_form/cubit_form/field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/cubit_form_text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubitForm = CubitFormCubit([
      OldCubitFormField<String>(
        id: 'one',
        initialValue: 'boy',
        validations: [
          ValidationModel((val) => val.isEmpty, 'empty'),
          ValidationModel((val) => val.length < 10, 'error'),
        ],
      ),
      OldCubitFormField<String>(
        id: 'another',
        initialValue: '',
        validations: [
          ValidationModel((val) => val.isEmpty, 'empty'),
        ],
      ),
    ], onSubmit: (values) {
      print(values);
    });

    return Scaffold(
      body: SafeArea(
        child: BlocProvider<CubitFormCubit>(
          create: (_) => cubitForm,
          child: Column(
            children: <Widget>[
              CubitFormTextField(
                fieldName: 'one',
                hintText: 'name',
              ),
              CubitFormTextField(
                fieldName: 'another',
                hintText: 'another text',
              ),
              RaisedButton(
                child: Text('hey'),
                onPressed: () {
                  cubitForm.trySubmit();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
