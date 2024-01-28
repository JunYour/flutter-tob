part of 'staff_apply_bloc.dart';

@immutable
abstract class StaffApplyEvent {}

///员工申请-未处理数量
class StaffApplyCountEvent extends StaffApplyEvent{
  final int bid;
  StaffApplyCountEvent(this.bid);
}
