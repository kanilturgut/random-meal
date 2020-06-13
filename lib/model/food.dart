import 'package:hive/hive.dart';

part 'food.g.dart';

@HiveType(typeId: 0)
class Food {
  @HiveField(0)
  final String name;

  Food(this.name);
}
