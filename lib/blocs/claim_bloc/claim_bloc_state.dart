part of 'claim_bloc_bloc.dart';

sealed class ClaimBlocState extends Equatable {
  const ClaimBlocState();
  
  @override
  List<Object> get props => [];
}

final class ClaimBlocInitial extends ClaimBlocState {}
