part of 'tab_purchase_list_bloc.dart';

@immutable
abstract class TabPurchaseListEvent {}

//列表
class TabPurchaseEntityEvent extends TabPurchaseListEvent{
  final List<CarOrderListList> carOrderListList;
  TabPurchaseEntityEvent(this.carOrderListList);
}
//根据id修改状态
class TabPurchaseEntityUpdByIdEvent extends TabPurchaseListEvent{
  final int id;
  final int status;
  final bool remove;
  TabPurchaseEntityUpdByIdEvent({this.id,this.status,this.remove});
}
