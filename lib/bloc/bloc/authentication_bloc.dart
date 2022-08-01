
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huawei_account/huawei_account.dart';

import '../../repositorys/userRepositoryHMS.dart';
import '../event/authencation_event.dart';
import '../state/authencation_state.dart';



class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // AuthenticationBloc(initialState) : super(initialState);
  final UserRepositoryHMS userRepository;
  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationStateInitial()) {
    on<AuthenticationEventStarted>(_onAuthenticationEventStarted);
    on<AuthenticationEventLogin>(_onAuthenticationEventLogin);
    on<AuthenticationEventLogout>(_onAuthenticationEventLogout);
  }

  void _onAuthenticationEventStarted(
      AuthenticationEventStarted event, Emitter emit) async {
    emit(AuthenticationStateInitial());
    bool isSignedIn = await userRepository.isSignInHMS();
    print('đăng nhập: $isSignedIn');
    if (await isSignedIn) {
      AuthAccount? user = await userRepository.getUserHMS();
      emit(AuthenticationStateSuccess(user: user));
    } else {
      AuthAccount? user = await userRepository.getUserHMS();
      print(user);
      emit(AuthenticationStateFailure());
    }
  }

  void _onAuthenticationEventLogin(
      AuthenticationEventLogin event, Emitter emit) async {
    emit(AuthenticationStateInitial());
   AuthAccount? user = await userRepository.getUserHMS();
    emit(AuthenticationStateSuccess(user: user));
  }

  void _onAuthenticationEventLogout(
      AuthenticationEventLogout event, Emitter emit) async {
    emit(AuthenticationStateInitial());
    userRepository.signOutHMS();
    emit(AuthenticationStateFailure());
  }
}
