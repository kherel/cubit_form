import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

abstract class Real extends FormCubit {
  Real() : super() {
    login = FieldCubit<String>(
      initalValue: 'Initial value',
      validations: [
        RequiredStringValidation('required'),
        ValidationModel((value) => value.length < 3, 'too small'),
        ValidationModel((value) => value.length > 20, 'too big'),
      ],
    )..stream.listen((_) {
        password.errorCheck();
      });

    password = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('required'),
        ValidationModel((value) => value.length < 3, 'too small'),
        ValidationModel((value) => value == login.state.value, 'same as login'),
      ],
    );

    zipCode = FieldCubit(
      initalValue: '123123123',
      validations: [
        RequiredStringValidation('Required'),
        RegExpValidation(
          RegExp(r'^(^\d{5}$)|(^\d{5}-\d{4}$)'),
          'should be 4 or 9 digets',
        ),
      ],
    );

    number = FieldCubit(
      initalValue: 100,
      validations: [RequiredIntValidation('required')],
    );
    var fields = [login, password, zipCode, number];
    addFields(fields);
  }
  late FieldCubit<String> login;
  late FieldCubit<String> password;
  late FieldCubit<String> zipCode;
  late FieldCubit<int> number;

  @override
  FutureOr<bool> asyncValidation() {
    // login.setError('here async error');
    return true;
  }
}

class RealChild extends Real {
  RealChild() {
    string = FieldCubit<String>(
      initalValue: 'aaa',
      validations: [
        RequiredStringValidation('required'),
      ],
    );
    var fields = [string];

    addFields(fields);
  }

  @override
  void onSubmit() async {
    print('===start===');
    await Future.delayed(Duration(seconds: 2));
    print(login.state.value);
    print(password.state.value);
    print(string.state.value);

    for (var f in fields) {
      f.reset();
    }
  }

  void setString() {
    string.externalSetValue('bbb');
  }

  @override
  reset() {
    for (var f in fields) {
      f.reset();
    }
  }

  late FieldCubit<String> string;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<RealChild>(
          create: (_) => RealChild(),
          child: Builder(builder: (context) {
            var formCubit = context.watch<RealChild>();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text('''
  validation rules:
  - login must be longer than 3 symbols and shorter than 10
  - password must be longer than 3 symbols and not the same as login
                      '''),
                  ),
                  Text(formCubit.login.state.value),
                  CubitFormTextField(
                    formFieldCubit: formCubit.login,
                    decoration: InputDecoration(
                      hintText: 'name',
                      labelText: 'login',
                    ),
                  ),
                  CubitFormIntField(
                    formFieldCubit: formCubit.number,
                    decoration: InputDecoration(
                      hintText: 'number',
                      labelText: 'count',
                    ),
                  ),
                  CubitFormTextField(
                    formFieldCubit: formCubit.password,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'another text',
                      labelText: 'password',
                    ),
                  ),
                  CubitFormMaskedTextField(
                    key: ValueKey('key111'),
                    formFieldCubit: formCubit.zipCode,
                    decoration: InputDecoration(
                        labelText: 'zipCode', helperText: 'zipCode'),
                    mask: '0000-0000',
                  ),
                  CubitFormMaskedTextField(
                    key: ValueKey('key'),
                    formFieldCubit: FieldCubit(
                      initalValue: '123123123',
                      validations: [
                        RequiredStringValidation('Required'),
                        RegExpValidation(
                          RegExp(r'^(^\d{5}$)|(^\d{5}-\d{4}$)'),
                          'should be 4 or 9 digets',
                        ),
                      ],
                    ),
                    decoration: InputDecoration(
                        labelText: 'zipCode', helperText: 'zipCode'),
                    mask: '0000-0000',
                  ),
                  CubitFormTextField(
                    cursorColor: Colors.red,
                    formFieldCubit: formCubit.string,
                    decoration: InputDecoration(
                      hintText: 'another string',
                      labelText: 'string',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                          ),
                          onPressed: () => formCubit.setString(),
                        ),
                      ),
                    ),
                  ),
                  if (formCubit.state.hasErrorToShow)
                    Center(
                      child: _Error(
                        child: Text('Not valid'),
                      ),
                    ),
                  Text(formCubit.state.isInitial ? "inital" : 'changed'),
                  if (!formCubit.state.hasErrorToShow)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text(formCubit.state.isSubmitting
                                ? 'Submiting'
                                : 'Submit'),
                            onPressed: formCubit.state.isSubmitting
                                ? null
                                : () => formCubit.trySubmit(),
                          ),
                          ElevatedButton(
                            child: Text('Reset'),
                            onPressed: () => formCubit.reset(),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        constraints: BoxConstraints(minWidth: 88.0, minHeight: 36.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.red,
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: child,
        ),
      ),
    );
  }
}
