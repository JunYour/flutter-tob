part of 'purchase_detail_bloc.dart';

@immutable
abstract class PurchaseDetailEvent {}

class PurchaseDetailInitEvent extends PurchaseDetailEvent{
  final int id;
  final bool clear;
  PurchaseDetailInitEvent({this.id,this.clear});
}


