part of 'notice_bloc.dart';

@immutable
abstract class NoticeEvent {}

class NoticeLoadEvent extends NoticeEvent{
  final bool reload;
  NoticeLoadEvent({this.reload});
}
