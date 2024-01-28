part of 'purchase_list_bloc.dart';

@immutable
abstract class PurchaseListEvent {}

class PurchaseListRefreshEvent extends PurchaseListEvent{
  final bool refresh;
  PurchaseListRefreshEvent(this.refresh);
}
