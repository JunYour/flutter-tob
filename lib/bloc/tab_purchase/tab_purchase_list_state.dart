part of 'tab_purchase_list_bloc.dart';

@immutable
abstract class TabPurchaseListState {
}
class TabPurchaseListInitial extends TabPurchaseListState {
    static List<CarOrderListList> carOrderListList;
}

class TabPurchaseListEntityState extends TabPurchaseListState{
    final List<CarOrderListList> carOrderListList;
    TabPurchaseListEntityState({this.carOrderListList});

}

