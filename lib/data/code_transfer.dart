import 'dart:typed_data';

class CodeTransfer {
  String? mimeType;
  String? fileName;
  String id;

  Uint8List? data;

  CodeTransfer({required this.id, this.mimeType, this.fileName, this.data});

  factory CodeTransfer.fromJson(Map<String, dynamic> json) => CodeTransfer(
        id: json['id'],
        fileName: json['fileName'],
        mimeType: json['mimeType'],
      );

  Map<String, dynamic> toJson() =>
      {'mimeType': mimeType, 'fileName': fileName, 'id': id};
}
