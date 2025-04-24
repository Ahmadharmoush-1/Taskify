import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/tasks_form_screen.dart';
import '../models/category.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/category_list.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text('Select Color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Colors.blue,
                Colors.green,
                Colors.amber,
                Colors.purple,
                Colors.pink,
                Colors.red,
                Colors.cyan,
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    selectedColor = color;
                    Navigator.of(ctx).pop();
                    _showAddCategoryDialog(); // Reopen dialog with selected color
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: selectedColor == color
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                final category = Category(
                  name: categoryController.text,
                  color: selectedColor,
                );
                Provider.of<TaskProvider>(context, listen: false)
                    .addCategory(category);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Taskify'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Taskify',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                CategoryList(
                  categories: taskProvider.categories,
                  selectedCategory: taskProvider.selectedCategory,
                  onCategorySelected: (category) {
                    taskProvider.setFilter(category: category);
                    Navigator.pop(context); // Close drawer
                  },
                  onAddCategory: () {
                    Navigator.pop(context); // Close drawer first
                    _showAddCategoryDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
              ),
              onChanged: (value) {
                taskProvider.setFilter(searchQuery: value);
              },
            ),
          ),
          Expanded(
            child: TaskList(
              tasks: taskProvider.filteredTasks,
              onDeleteTask: taskProvider.deleteTask,
              onToggleTaskCompletion: taskProvider.toggleTaskCompletion,
              onUpdateTask: taskProvider.updateTask,
              onAddTask: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskFormScreen()),
              ),
              showCompleted: taskProvider.showCompleted,
              onToggleShowCompleted: (value) {
                taskProvider.setFilter(showCompleted: value);
              },
              getCategoryColor: (categoryName) {
                return taskProvider.getCategoryColor(categoryName);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
