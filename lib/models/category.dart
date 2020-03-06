import 'package:hive/hive.dart';
import 'goal.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  String categoryName;
  @HiveField(1)
  HiveList goals;

  Category(this.categoryName, this.goals);
}
