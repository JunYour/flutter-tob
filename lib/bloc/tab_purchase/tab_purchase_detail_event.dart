part of 'tab_purchase_detail_bloc.dart';

@immutable
abstract class TabPurchaseDetailEvent {}

class TabPurchaseDetailEntityEvent extends TabPurchaseDetailEvent{
  final CarOrderDetailEntity carOrderDetailEntity;
  TabPurchaseDetailEntityEvent(this.carOrderDetailEntity);
}
