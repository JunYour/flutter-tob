part of 'address_bloc.dart';

@immutable
abstract class AddressEvent {}

class AddressReFreshEvent extends AddressEvent{
  final bool refresh;
  AddressReFreshEvent({this.refresh});
}
