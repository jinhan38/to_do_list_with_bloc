import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int id;
  final String name;
  final int age;

  Person({required this.id, required this.name, required this.age});

  @override
  List<Object?> get props => [this.id, this.name, this.age];
}
