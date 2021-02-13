import 'package:equatable/equatable.dart';
import 'package:nekidaem_flutter/models/user.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final User user;

  LoginButtonPressed({this.user});

  @override
  List<Object> get props => [user];
}

