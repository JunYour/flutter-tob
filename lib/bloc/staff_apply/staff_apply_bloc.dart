import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/network/http.dart';

part 'staff_apply_event.dart';
part 'staff_apply_state.dart';

class StaffApplyBloc extends Bloc<StaffApplyEvent, StaffApplyState> {
  StaffApplyBloc() : super(StaffApplyInitial());

  @override
  Stream<StaffApplyState> mapEventToState(
    StaffApplyEvent event,
  ) async* {
    if(event is StaffApplyCountEvent){
      ///员工申请未处理数量
      BaseEntity baseEntity =  await Http.getInstance().staffApplyCount(bid: event.bid);
      yield StaffApplyCountState(int.parse(baseEntity.data.toString()));
    }
  }
}
