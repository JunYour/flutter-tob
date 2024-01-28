import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial());

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    if(event is AddressReFreshEvent){
      yield AddressRefreshState(refresh: event.refresh);
    }
  }
}
