// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
