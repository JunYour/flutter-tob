part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressRefreshState extends AddressState{
  final bool refresh;
  AddressRefreshState({this.refresh});
}
