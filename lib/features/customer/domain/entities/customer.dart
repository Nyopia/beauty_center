import 'package:beauty_center/package_export.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String? note;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.note,
  });

  @override
  List<Object?> get props => [id, name, phoneNumber, note];
}
