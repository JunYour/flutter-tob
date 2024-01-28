import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tob/entity/purchase/purchase_num_entity.dart';
import 'package:tob/network/http.dart';

part 'purchase_num_event.dart';
part 'purchase_num_state.dart';

class PurchaseNumBloc extends Bloc<PurchaseNumEvent, PurchaseNumState> {
  PurchaseNumBloc() : super(PurchaseNumInitial());

  @override
  Stream<PurchaseNumState> mapEventToState(
    PurchaseNumEvent event,
  ) async* {
    if(event is PurchaseNumInitEvent){
      PurchaseNumEntity purchaseNumEntity;
      purchaseNumEntity = await Http.getInstance().purchaseNum(oid: event.oid);
      yield PurchaseNumInitState(purchaseNumEntity);
    }
  }
}
