// ignore_for_file: non_constant_identifier_names

part of 'objects.dart';

@JsonSerializable()
class GetExpenseTypes {
  final String? SAVCT_TYPE;
  final String? SAVCT_DESCRIPTION;
  final int? SAVCT_SEQ;

  GetExpenseTypes({
    this.SAVCT_TYPE,
    this.SAVCT_DESCRIPTION,
    this.SAVCT_SEQ,
  });

  factory GetExpenseTypes.fromJson(Map<String, dynamic> json) =>
      _$GetExpenseTypesFromJson(json);

  Map<String, dynamic> toJson() => _$GetExpenseTypesToJson(this);
}
