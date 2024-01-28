import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/userInfo.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(UserState(UserInfo.getUserInfo()));

  @override
  Stream<UserInfoState> mapEventToState(
    UserInfoEvent event,
  ) async* {
    if(event is UserStateEvent){
      yield UserState(UserInfo.getUserInfo());
    }
  }
}
