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
  void onSubmit() async {
    print('===start===');
    await Future.delayed(Duration(seconds: 2));
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
                formFieldCubit: formReal.login,
                decoration: InputDecoration(
                  hintText: 'name',
                  labelText: 'login',
                ),
              ),
              CubitFormTextField(
                formFieldCubit: formReal.password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'another text',
                  labelText: 'password',
                ),
              ),
              BlocBuilder<Real, FormCubitState>(
                  cubit: formReal,
                  builder: (context, state) {
                    print(state.isErrorShown);

                    if (state.isFormValid || !state.isErrorShown) {
                      return Center(
                        child: RaisedButton(
                          child:
                              Text(state.isSubmitting ? 'Submiting' : 'Submit'),
                          onPressed:
                              state.isSubmitting ? null : formReal.trySubmit,
                        ),
                      );
                    } else {
                      return Center(
                        child: _Error(
                          child: Text('Not valid'),
                        ),
                      );
                    }
                  })
            ],
          ),
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
