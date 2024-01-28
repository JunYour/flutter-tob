part of 'staff_apply_bloc.dart';

@immutable
abstract class StaffApplyState {}

class StaffApplyInitial extends StaffApplyState {}

///员工申请未处理数量
class StaffApplyCountState extends StaffApplyState{
  final int count;
  StaffApplyCountState(this.count);
}
