part of 'tab_purchase_detail_bloc.dart';

@immutable
abstract class TabPurchaseDetailState {}

class TabPurchaseDetailInitial extends TabPurchaseDetailState {}

class TabPurchaseDetailEntityState extends TabPurchaseDetailState{
  final CarOrderDetailEntity carOrderDetailEntity;
  TabPurchaseDetailEntityState(this.carOrderDetailEntity);
}
