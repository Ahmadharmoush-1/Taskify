import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final Function() onAddCategory;

  const CategoryList({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('All Tasks'),
              selected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
            ...categories
                .map((category) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color,
                        radius: 12,
                      ),
                      title: Text(category.name),
                      selected: selectedCategory == category.name,
                      onTap: () => onCategorySelected(category.name),
                    ))
                .toList(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: onAddCategory,
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
          ),
        ),
      ],
    );
  }
}
