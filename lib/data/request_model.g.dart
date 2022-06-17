// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      ipAddress: json['ip_address'] as String,
      port: json['port'] as int? ?? 4040,
      deviceName: json['device_name'] as String,
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'ip_address': instance.ipAddress,
      'port': instance.port,
      'device_name': instance.deviceName,
    };
