part of 'purchase_detail_bloc.dart';

@immutable
abstract class PurchaseDetailState {}

class PurchaseDetailInitial extends PurchaseDetailState {}

// ignore: must_be_immutable
class PurchaseDetailInitState extends PurchaseDetailState{
  PurchaseDetailEntity purchaseDetailEntity;

  PurchaseDetailInitState(this.purchaseDetailEntity);
}

