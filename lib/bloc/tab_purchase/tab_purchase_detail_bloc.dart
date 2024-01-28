import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/tab_purchase/car_order_detail_entity.dart';

part 'tab_purchase_detail_event.dart';
part 'tab_purchase_detail_state.dart';

class TabPurchaseDetailBloc extends Bloc<TabPurchaseDetailEvent, TabPurchaseDetailState> {
  TabPurchaseDetailBloc() : super(TabPurchaseDetailInitial());

  @override
  Stream<TabPurchaseDetailState> mapEventToState(
    TabPurchaseDetailEvent event,
  ) async* {
    if(event is TabPurchaseDetailEntityEvent){
      yield TabPurchaseDetailEntityState(event.carOrderDetailEntity);
    }
  }
}
