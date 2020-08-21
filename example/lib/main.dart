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
                hintText: 'name',
                labeText: 'login',
              ),
              CubitFormTextField(
                formFieldCubit: formReal.password,
                obscureText: true,
                hintText: 'another text',
                labeText: 'password',
              ),
              BlocBuilder<Real, FormCubitState>(
                  cubit: formReal,
                  builder: (context, state) {
                    return Center(
                      child: RaisedButton(
                        child: Text('submit'),
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                formReal.trySubmit();
                              },
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
