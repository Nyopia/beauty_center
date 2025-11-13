import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String name;
  final double price;
  final int durationInMinutes;

  const Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInMinutes,
  });

  @override
  List<Object?> get props => [id, name, price, durationInMinutes];
}
