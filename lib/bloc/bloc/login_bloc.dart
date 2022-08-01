
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huawei_account/huawei_account.dart';

import '../../repositorys/userRepositoryHMS.dart';
import '../event/login_event.dart';
import '../state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent,UserState>{
  //LoginBloc(LoginState initialState) : super(initialState);
  UserRepositoryHMS userRepository;

  LoginBloc({required this.userRepository}) : super(UserStateInitial())
  {
  on<LoginEventWithHMSPressed>(_onLoginEventWithEmailAndPasswordPressed,transformer: sequential(),);


}




void _onLoginEventWithEmailAndPasswordPressed(
    LoginEventWithHMSPressed event, Emitter emit) async {
    emit(UserStateInitial());
    await userRepository.signInWithHMSCore();
     print('usser: ${await userRepository.getUserHMS()}');
    await Future.delayed(const Duration(seconds: 1));

    try{
      await userRepository.signInWithHMSCore();
      // print('usser: ${await userRepository.getUser()}');
      await Future.delayed(const Duration(seconds: 1));

      AuthAccount account =await userRepository.getUserHMS();


      emit(UserStateSuccess(user: account));
    }catch(_){
      emit(UserStateFail());
    }
}
}
