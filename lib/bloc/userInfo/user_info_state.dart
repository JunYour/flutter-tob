part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoState {}

// ignore: must_be_immutable
class UserState extends UserInfoState{
  UserInfoEntity userInfoEntity;
  UserState(this.userInfoEntity);
}
