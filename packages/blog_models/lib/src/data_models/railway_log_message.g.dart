// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'railway_log_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RailwayLogMessage _$RailwayLogMessageFromJson(Map<String, dynamic> json) =>
    RailwayLogMessage(
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      logLevel: $enumDecodeNullable(_$LogLevelEnumMap, json['log_level']) ??
          LogLevel.info,
    );

Map<String, dynamic> _$RailwayLogMessageToJson(RailwayLogMessage instance) =>
    <String, dynamic>{
      'log_level': _$LogLevelEnumMap[instance.logLevel]!,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$LogLevelEnumMap = {
  LogLevel.info: 'info',
  LogLevel.error: 'error',
};
