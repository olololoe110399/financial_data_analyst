import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';

class ModelOption {
  final String id;
  final String name;
  final Models model;
  ModelOption({required this.id, required this.name, required this.model});
}
