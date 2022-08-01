import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginEventEmailInit extends LoginEvent{}


class LoginEventWithHMSPressed extends LoginEvent{
  LoginEventWithHMSPressed();
  @override
  // TODO: implement props
  List<Object?> get props => [];
  @override
  String toString() {
    // TODO: implement toString
    return "LoginEventWithEmailAndPasswordPressed: ";
  }
}