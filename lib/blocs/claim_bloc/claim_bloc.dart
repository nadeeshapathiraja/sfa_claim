import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sfa_claim/controller/claim_controller.dart';
import 'package:sfa_claim/model/objects.dart';

//--------------Bloc State---------------//
class ClaimState extends Equatable {
  @override
  List<Object?> get props => [];
}

//Initial state
class ClaimInitial extends ClaimState {
  @override
  List<Object?> get props => [];
}

//Loading state
class ClaimLoading extends ClaimState {
  @override
  List<Object?> get props => [];
}

//Error state
class ClaimError extends ClaimState {
  @override
  List<Object?> get props => [];
}

//Data loaded state
class ClaimLoaded extends ClaimState {
  @override
  List<Object?> get props => [];
}

//--------------Bloc Event---------------//
class ClaimEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetClaimType extends ClaimEvent {
  final String com;
  final BuildContext context;

  GetClaimType({required this.context, required this.com});
  @override
  List<Object?> get props => [];
}

class ClaimBloc extends Bloc<ClaimEvent, ClaimState> {
  ClaimBloc() : super(ClaimInitial()) {
    on<ClaimEvent>((event, emit) async {
      if (event is GetClaimType) {
        emit(ClaimLoading());
        await ClaimsController().getDoConfirmResons(
          com: event.com,
          context: event.context,
        );
        emit(ClaimLoading());
      }
    });
  }
}
