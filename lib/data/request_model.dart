import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

@JsonSerializable()
class RequestModel {
  @JsonKey(name: 'ip_address')
  String ipAddress;
  @JsonKey(name: 'port')
  int port;
  @JsonKey(name: 'device_name')
  String deviceName;

  RequestModel(
      {required this.ipAddress, this.port = 4040, required this.deviceName});

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);
}
