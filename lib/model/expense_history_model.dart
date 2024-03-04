// ignore_for_file: non_constant_identifier_names

part of 'objects.dart';

@JsonSerializable()
class GetExpenseHistory {
  final String? SAVCD_VISIT_NO;
  final int? SAVCD_LINE;
  final String? SAVCD_DT;
  final String? SAVCD_TYPE;
  final String? SAVCD_REMARK;
  final String? SAVCD_AMOUNT;
  final String? SAVCD_STATUS;
  final double? IMAGECOUNT;

  GetExpenseHistory({
    this.SAVCD_VISIT_NO,
    this.SAVCD_LINE,
    this.SAVCD_DT,
    this.SAVCD_TYPE,
    this.SAVCD_REMARK,
    this.SAVCD_AMOUNT,
    this.SAVCD_STATUS,
    this.IMAGECOUNT,
  });

  factory GetExpenseHistory.fromJson(Map<String, dynamic> json) =>
      _$GetExpenseHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$GetExpenseHistoryToJson(this);
}
