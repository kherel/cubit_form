import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Real extends FormCubit {
  Real() : super() {
    login = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('required'),
        ValidationModel((value) => value.length < 3, 'too small'),
        ValidationModel((value) => value.length > 10, 'too big'),
      ],
    )..listen((_) {
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

    string = FieldCubit<String>(
      initalValue: 'aaa',
      validations: [
        RequiredStringValidation('required'),
      ],
    );
    var fields = [login, password, string];
    super.setFields(fields);
  }
  FieldCubit login;

  FieldCubit password;

  FieldCubit string;

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

  @override
  FutureOr<bool> asyncValidation() {
    // login.setError('here async error');
    return true;
  }

  void setString() {
    string.externalSetValue('bbb');
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<Real>(
          create: (_) => Real(),
          child: Builder(builder: (context) {
            var realForm = context.watch<Real>();
            return Column(
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
                CubitFormTextField(
                  formFieldCubit: realForm.login,
                  decoration: InputDecoration(
                    hintText: 'name',
                    labelText: 'login',
                  ),
                ),
                CubitFormTextField(
                  formFieldCubit: realForm.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'another text',
                    labelText: 'password',
                  ),
                ),
                CubitFormTextField(
                  formFieldCubit: realForm.string,
                  decoration: InputDecoration(
                    hintText: 'another string',
                    labelText: 'string',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                        ),
                        onPressed: realForm.setString,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<Real, FormCubitState>(
                    cubit: realForm,
                    builder: (context, state) {
                      if (state.hasErrorToShow) {
                        return Center(
                          child: _Error(
                            child: Text('Not valid'),
                          ),
                        );
                      } else {
                        return Center(
                          child: RaisedButton(
                            child: Text(
                                state.isSubmitting ? 'Submiting' : 'Submit'),
                            onPressed:
                                state.isSubmitting ? null : realForm.trySubmit,
                          ),
                        );
                      }
                    })
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({Key key, this.child}) : super(key: key);

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
