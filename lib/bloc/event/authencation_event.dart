import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class AuthenticationEventStarted extends AuthenticationEvent{}
class AuthenticationEventLogin extends AuthenticationEvent{}
class AuthenticationEventLogout extends AuthenticationEvent{}