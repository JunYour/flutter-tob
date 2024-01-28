import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/bloc/tab/switch_tag_state.dart';

class SwitchTagBloc extends Bloc<SwitchTagEvent, SwitchTagState> {
  SwitchTagBloc() : super(null);

  @override
  Stream<SwitchTagState> mapEventToState(SwitchTagEvent event) async* {
    if (event is SetSwitchTagEvent) {
      yield SetSwitchTagState(event.tagEntity);
    } else if (event is ResetSwitchTagEvent) {
      yield ResetSwitchTagState();
    } else if (event is JustSwitchTagEvent) {
      yield JustSwitchTagState(event.index,content: event?.content,reFresh: event?.reFresh,toOrder: event?.toOrder);
    }else if (event is BuyCarNumEvent) {
      yield BuyCarNumState(event.num);
    }
  }
}
