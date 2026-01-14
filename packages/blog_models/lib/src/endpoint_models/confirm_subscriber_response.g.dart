// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_subscriber_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmSubscriberResponse _$ConfirmSubscriberResponseFromJson(
  Map<String, dynamic> json,
) => ConfirmSubscriberResponse(
  statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ConfirmSubscriberResponseToJson(
  ConfirmSubscriberResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
};
