import 'package:cubit_form/cubit_form/field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/cubit_form_text_field.dart';
import 'logic/form_cubit/form_cubit.dart';
import 'logic/field_cubit/field_cubit.dart';

void main() {
  runApp(MyApp());
}

class Real extends FormCubit {
  Real() : super() {
    login = FieldCubit<String>(
      initalValue: '',
      validations: [
        ValidationModel((value) => value.length < 3, 'too small'),
        ValidationModel((value) => value.length > 10, 'too big'),
      ],
    )..listen((_) {
        password.errorCheck();
      });

    password = FieldCubit<String>(
      initalValue: '',
      validations: [
        ValidationModel((value) => value.length < 3, 'too small'),
        ValidationModel((value) => value == login.state.value, 'same as login'),
      ],
    );
    var fields = [login, password];
    super.setFields(fields);
  }
  FieldCubit login;

  FieldCubit password;

  @override
  void onSubmit() {
    print(login.state.value);
    print(password.state.value);
  }
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

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Real formReal;

  @override
  void initState() {
    formReal = Real();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<Real>(
          create: (_) => formReal,
          child: Column(
            children: <Widget>[
              CubitFormTextField(
                formFieldCubit: formReal.login,
                hintText: 'name',
              ),
              CubitFormTextField(
                formFieldCubit: formReal.password,
                hintText: 'another text',
              ),
              RaisedButton(
                child: Text('hey'),
                onPressed: () {
                  formReal.trySubmit();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
