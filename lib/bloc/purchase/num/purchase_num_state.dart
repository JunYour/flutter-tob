part of 'purchase_num_bloc.dart';

@immutable
abstract class PurchaseNumState {}

class PurchaseNumInitial extends PurchaseNumState {}

class PurchaseNumInitState extends PurchaseNumState{
  final PurchaseNumEntity purchaseNumEntity;
  PurchaseNumInitState(this.purchaseNumEntity);
}
