part of 'purchase_list_bloc.dart';

@immutable
abstract class PurchaseListState {}

class PurchaseListInitial extends PurchaseListState {}

class PurchaseListRefreshState extends PurchaseListState{
  final bool refresh;
  PurchaseListRefreshState(this.refresh);
}
