

import 'package:equatable/equatable.dart';
import 'package:huawei_account/huawei_account.dart';
import 'package:meta/meta.dart';

abstract class UserState extends Equatable{
  const UserState();
  @override
  // TODO: implement props
  List<Object?> get props =>[];

}
class  UserStateInitial extends  UserState{}
class  UserStateLoading extends  UserState{}
class  UserStateSuccess extends  UserState{
  final AuthAccount user;
  const UserStateSuccess({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
class  UserStateFail extends UserState{}
