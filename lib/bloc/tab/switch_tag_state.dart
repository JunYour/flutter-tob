

import 'package:tob/bloc/tab/tag_entity.dart';

abstract class SwitchTagState {}

class SetSwitchTagState extends SwitchTagState {
  TagEntity tagEntity;

  SetSwitchTagState(this.tagEntity);
}

class ResetSwitchTagState extends SwitchTagState {}

class JustSwitchTagState extends SwitchTagState {
  int index;
  String content;
  bool reFresh;
  bool toOrder;
  JustSwitchTagState(this.index,{this.content,this.reFresh,this.toOrder});
}



class BuyCarNumState extends SwitchTagState{
  int num;
  BuyCarNumState(this.num);
}
