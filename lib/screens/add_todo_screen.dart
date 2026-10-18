import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../theme/app_theme.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  TodoCategory _category = TodoCategory.personal;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, Todo(_title.text.trim(), category: _category));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New task')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('What needs to be done?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                autofocus: true,
                maxLength: 60,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'e.g. Finish UI assignment',
                  prefixIcon: Icon(Icons.edit_outlined, color: AppColors.dim),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Please enter a task title';
                  if (t.length < 3) return 'Title must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Category',
                  style: TextStyle(
                      color: AppColors.dim, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: TodoCategory.values.map((c) {
                  final selected = _category == c;
                  return ChoiceChip(
                    avatar: Icon(c.icon,
                        size: 18, color: selected ? Colors.black : c.color),
                    label: Text(c.label),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: AppColors.gold,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.black : Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
