import 'package:flutter/material.dart';

enum TodoCategory { personal, study, work, shopping }

extension TodoCategoryX on TodoCategory {
  String get label => switch (this) {
        TodoCategory.personal => 'Personal',
        TodoCategory.study => 'Study',
        TodoCategory.work => 'Work',
        TodoCategory.shopping => 'Shopping',
      };

  IconData get icon => switch (this) {
        TodoCategory.personal => Icons.person_outline_rounded,
        TodoCategory.study => Icons.menu_book_rounded,
        TodoCategory.work => Icons.work_outline_rounded,
        TodoCategory.shopping => Icons.shopping_bag_outlined,
      };

  Color get color => switch (this) {
        TodoCategory.personal => const Color(0xFFB07CFF),
        TodoCategory.study => const Color(0xFF4DB6FF),
        TodoCategory.work => const Color(0xFFE6C068),
        TodoCategory.shopping => const Color(0xFFFF7A9C),
      };
}

class Todo {
  String title;
  TodoCategory category;
  bool isDone;

  Todo(this.title, {this.category = TodoCategory.personal, this.isDone = false});
}
