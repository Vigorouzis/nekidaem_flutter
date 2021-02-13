import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_flutter/blocs/login_bloc/login.dart';
import 'package:nekidaem_flutter/models/user.dart';
import 'package:nekidaem_flutter/pages/kanban_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  User _user = User();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Kanban'),
        backgroundColor: Colors.grey[800],
      ),
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => KanbanPage()));
            }
            if (state is LoginFailed)
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is InitLoginState ||
                  state is LoginLoading ||
                  state is LoginSuccess ||
                  state is LoginFailed) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _user.username = value;
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
                            hintText: 'Enter your username',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.cyanAccent),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _user.password = value;
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0)),
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Colors.cyanAccent),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () =>
                            _loginBloc.add(LoginButtonPressed(user: _user)),
                        child: Text('Login'),
                        color: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
