import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/purchase/purchase_detail_entity.dart';
import 'package:tob/network/http.dart';

part 'purchase_detail_event.dart';
part 'purchase_detail_state.dart';

class PurchaseDetailBloc extends Bloc<PurchaseDetailEvent, PurchaseDetailState> {
  PurchaseDetailBloc() : super(PurchaseDetailInitial());

  @override
  Stream<PurchaseDetailState> mapEventToState(
    PurchaseDetailEvent event,
  ) async* {
    if(event is PurchaseDetailInitEvent){
      if(event.clear == false){
        PurchaseDetailEntity purchaseDetailEntity;
        purchaseDetailEntity = await Http.getInstance().purchaseDetail(id: event.id);
        yield PurchaseDetailInitState(purchaseDetailEntity);
      }else{
        yield PurchaseDetailInitState(null);
      }
    }
  }
}
