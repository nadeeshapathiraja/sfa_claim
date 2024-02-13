import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'claim_bloc_event.dart';
part 'claim_bloc_state.dart';

class ClaimBlocBloc extends Bloc<ClaimBlocEvent, ClaimBlocState> {
  ClaimBlocBloc() : super(ClaimBlocInitial()) {
    on<ClaimBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
