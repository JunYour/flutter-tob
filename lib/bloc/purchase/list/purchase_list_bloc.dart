import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'purchase_list_event.dart';
part 'purchase_list_state.dart';

class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  PurchaseListBloc() : super(PurchaseListInitial());

  @override
  Stream<PurchaseListState> mapEventToState(
    PurchaseListEvent event,
  ) async* {
    if(event is PurchaseListRefreshEvent){
      yield PurchaseListRefreshState(event.refresh);
    }
  }
}
