part of 'notice_bloc.dart';

@immutable
abstract class NoticeState {}

// ignore: must_be_immutable
class NoticeInitial extends NoticeState {

}

class NoticeLoadState extends NoticeState{
  final NoticeCountEntity noticeCountEntity;
  NoticeLoadState(this.noticeCountEntity);
}
