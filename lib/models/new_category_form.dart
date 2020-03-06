import 'package:hive/hive.dart';
import 'category.dart';

class NewCategoryFormState {
  final categoryBox = Hive.box('categorys');

  void _addCategory(Category category) {
    categoryBox.add(category);
  }

  void setCategory(String name) {
    List goal;
    final newCategory = Category(name, goal);
    _addCategory(newCategory);
  }
}
