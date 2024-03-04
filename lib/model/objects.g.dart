// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetExpenseHistory _$GetExpenseHistoryFromJson(Map<String, dynamic> json) =>
    GetExpenseHistory(
      SAVCD_VISIT_NO: json['SAVCD_VISIT_NO'] as String?,
      SAVCD_LINE: json['SAVCD_LINE'] as int?,
      SAVCD_DT: json['SAVCD_DT'] as String?,
      SAVCD_TYPE: json['SAVCD_TYPE'] as String?,
      SAVCD_REMARK: json['SAVCD_REMARK'] as String?,
      SAVCD_AMOUNT: json['SAVCD_AMOUNT'] as String?,
      SAVCD_STATUS: json['SAVCD_STATUS'] as String?,
      IMAGECOUNT: (json['IMAGECOUNT'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GetExpenseHistoryToJson(GetExpenseHistory instance) =>
    <String, dynamic>{
      'SAVCD_VISIT_NO': instance.SAVCD_VISIT_NO,
      'SAVCD_LINE': instance.SAVCD_LINE,
      'SAVCD_DT': instance.SAVCD_DT,
      'SAVCD_TYPE': instance.SAVCD_TYPE,
      'SAVCD_REMARK': instance.SAVCD_REMARK,
      'SAVCD_AMOUNT': instance.SAVCD_AMOUNT,
      'SAVCD_STATUS': instance.SAVCD_STATUS,
      'IMAGECOUNT': instance.IMAGECOUNT,
    };

GetExpenseTypes _$GetExpenseTypesFromJson(Map<String, dynamic> json) =>
    GetExpenseTypes(
      SAVCT_TYPE: json['SAVCT_TYPE'] as String?,
      SAVCT_DESCRIPTION: json['SAVCT_DESCRIPTION'] as String?,
      SAVCT_SEQ: json['SAVCT_SEQ'] as int?,
    );

Map<String, dynamic> _$GetExpenseTypesToJson(GetExpenseTypes instance) =>
    <String, dynamic>{
      'SAVCT_TYPE': instance.SAVCT_TYPE,
      'SAVCT_DESCRIPTION': instance.SAVCT_DESCRIPTION,
      'SAVCT_SEQ': instance.SAVCT_SEQ,
    };
