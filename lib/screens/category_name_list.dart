import 'package:flutter/material.dart';
import 'package:focusplanner/models/category.dart';

class CategoryNameList extends StatefulWidget {
  final List categoryList;
  final List selectedCategories;
  final Function onSelectChanged;
  CategoryNameList(
      {this.categoryList, this.selectedCategories, this.onSelectChanged});

  @override
  _CategoryNameListState createState() => _CategoryNameListState();
}

class _CategoryNameListState extends State<CategoryNameList> {
  List<Widget> _buildChoiceList() {
    List<Widget> choices = List();
    widget.categoryList.cast<Category>().forEach((category) {
      choices.add(ChoiceChip(
        key: UniqueKey(),
        label: Text(
          category.name,
          style: TextStyle(
            color: category.getTextColor(),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: category.getColor(),
        selectedColor: category.getColor().withOpacity(0.6),
        selected: widget.selectedCategories.contains(category),
        onSelected: (selected) {
          setState(() {
            widget.selectedCategories.contains(category)
                ? widget.selectedCategories.remove(category)
                : widget.selectedCategories.add(category);
          });
          widget.onSelectChanged();
        },
      ));
    });
    return choices;
  }

  setCategoryPriority() {
    int index = 0;
    widget.categoryList.cast<Category>().forEach((category) {
      category.changePriority(index);
      category.save();
      index++;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    Future.delayed(Duration(milliseconds: 20), () {
      setState(() {
        final Category category = widget.categoryList.removeAt(oldIndex);
        widget.categoryList.insert(newIndex, category);
      });
      setCategoryPriority();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ReorderableListView(
        children: _buildChoiceList(),
        onReorder: _onReorder,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
