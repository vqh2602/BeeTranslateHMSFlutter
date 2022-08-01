import 'package:equatable/equatable.dart';
import 'package:huawei_account/huawei_account.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {
  final AuthAccount user;
  const AuthenticationStateSuccess({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
  @override
  String toString() {
    // TODO: implement toString
    return "AuthenticationStatéuccess: ${user.email}";
  }
}

class AuthenticationStateFailure extends AuthenticationState {}
