import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/tab_purchase/car_order_list_entity.dart';

part 'tab_purchase_list_event.dart';
part 'tab_purchase_list_state.dart';

class TabPurchaseListBloc extends Bloc<TabPurchaseListEvent, TabPurchaseListState> {
  TabPurchaseListBloc() : super(TabPurchaseListInitial());

  @override
  Stream<TabPurchaseListState> mapEventToState(
    TabPurchaseListEvent event,
  ) async* {
    if(event is TabPurchaseEntityEvent){
      TabPurchaseListInitial.carOrderListList =  event.carOrderListList;
      yield TabPurchaseListEntityState(carOrderListList: event.carOrderListList);
    }else if(event is TabPurchaseEntityUpdByIdEvent){
      List<CarOrderListList> carOrderList;
      carOrderList = TabPurchaseListInitial.carOrderListList;
      int index = 0;
      carOrderList.asMap().forEach((key, value) {
        if(value.id == event.id){
          value.status = event.status;
          index = key;
        }
      });
      if(event.remove == true){
        carOrderList.removeAt(index);
      }
      yield TabPurchaseListEntityState(carOrderListList: carOrderList);
    }
  }
}
