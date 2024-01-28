part of 'purchase_num_bloc.dart';

@immutable
abstract class PurchaseNumEvent {}

class PurchaseNumInitEvent extends PurchaseNumEvent{
  final int oid;
  PurchaseNumInitEvent({this.oid});
}
