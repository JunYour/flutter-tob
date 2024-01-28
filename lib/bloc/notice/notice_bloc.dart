import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/notice/notice_count_entity.dart';
import 'package:tob/network/http.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  NoticeBloc() : super(NoticeInitial());

  @override
  Stream<NoticeState> mapEventToState(
    NoticeEvent event,
  ) async* {
    if(event is NoticeLoadEvent){
      if(event.reload == true){
        NoticeCountEntity noticeCountEntity;
        noticeCountEntity = await Http.getInstance().noticeCount();
        print('123');
        yield NoticeLoadState(noticeCountEntity);
      }
    }
  }
}
