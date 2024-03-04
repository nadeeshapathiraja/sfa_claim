// ignore_for_file: must_be_immutable

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
  List<GetExpenseTypes> expensetype = [];
  ClaimLoaded({required this.expensetype});
  @override
  List<Object?> get props => [expensetype];
}

class Claimhistory extends ClaimState {
  String visitNumber = '';
  String dateRange = '';
  String vehicleType = '';
  String fuelType = '';
  String year = '';
  String month = '';
  String baseLocation = '';
  double totalClaims = 0;
  Claimhistory({
    required this.visitNumber,
    required this.dateRange,
    required this.vehicleType,
    required this.fuelType,
    required this.year,
    required this.month,
    required this.baseLocation,
    required this.totalClaims,
  });
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
  List<GetExpenseTypes> exptype = [];
  ClaimBloc() : super(ClaimInitial()) {
    on<ClaimEvent>((event, emit) async {
      if (event is GetClaimType) {
        emit(ClaimLoading());
        exptype = await ClaimsController().getDoConfirmResons(
          com: event.com,
          context: event.context,
        );

        emit(ClaimLoaded(expensetype: exptype));
      }
    });
  }
}
