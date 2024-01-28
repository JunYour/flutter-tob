
import 'package:tob/bloc/tab/tag_entity.dart';

abstract class SwitchTagEvent {}

class SetSwitchTagEvent extends SwitchTagEvent {
  TagEntity tagEntity;

  SetSwitchTagEvent(this.tagEntity);
}

class ResetSwitchTagEvent extends SwitchTagEvent {}

class JustSwitchTagEvent extends SwitchTagEvent {
  int index;
  String content;
  bool reFresh;
  bool toOrder;
  JustSwitchTagEvent(this.index,{this.content,this.reFresh,this.toOrder});
}

class BuyCarNumEvent extends SwitchTagEvent{
  int num;
  BuyCarNumEvent(this.num);
}

