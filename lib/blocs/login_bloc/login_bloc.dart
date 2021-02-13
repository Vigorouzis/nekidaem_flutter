import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_flutter/blocs/login_bloc/login_event.dart';
import 'package:nekidaem_flutter/blocs/login_bloc/login_state.dart';
import 'package:http/http.dart' as http;
import 'package:nekidaem_flutter/models/user.dart';
import 'package:nekidaem_flutter/services/shared_prefs.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitLoginState());

  SharedPrefs _prefs = SharedPrefs();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      var response = await http.post(
        'https://trello.backend.tests.nekidaem.ru/api/v1/users/login/',
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(event.user.toJson()),
      );

      if (response.statusCode == 200) {
        var token = jsonDecode(response.body);
        event.user.token = token['token'].toString();
        await _prefs.save('user', event.user.toJson());
        yield LoginSuccess();
      }

      if (response.statusCode == 400) {
        var errorMessage = jsonDecode(response.body);
        yield LoginFailed(errorMessage['non_field_errors'][0]);
        yield InitLoginState();
      }
    }
  }
}
