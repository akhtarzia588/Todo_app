import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  TodoCategory? _filter;

  Future<void> _openAdd() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result is Todo) setState(() => _todos.insert(0, result));
  }

  void _toggle(Todo t) => setState(() => t.isDone = !t.isDone);

  void _remove(Todo t) {
    final index = _todos.indexOf(t);
    setState(() => _todos.remove(t));
    final m = ScaffoldMessenger.of(context);
    m.clearSnackBars();
    m.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      content: Text('Deleted "${t.title}"',
          style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.gold,
        onPressed: () => setState(
            () => _todos.insert(index.clamp(0, _todos.length).toInt(), t)),
      ),
    ));
  }

  Widget _chip(TodoCategory? c, String label) {
    final selected = _filter == c;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = c),
        selectedColor: AppColors.gold,
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.black : AppColors.dim,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter == null
        ? _todos
        : _todos.where((t) => t.category == _filter).toList();
    final done = _todos.where((t) => t.isDone).length;
    final progress = _todos.isEmpty ? 0.0 : done / _todos.length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WELCOME BACK',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Text('My Todo',
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.violet.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$done of ${_todos.length} completed',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    _todos.isEmpty
                        ? 'Add your first task to begin'
                        : progress == 1
                            ? 'All done. Great work!'
                            : 'Keep going, you are doing great',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    builder: (_, v, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.gold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _chip(null, 'All'),
                  ...TodoCategory.values.map((c) => _chip(c, c.label)),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Opacity(
                              opacity: 0.35, child: AppLogo(size: 100)),
                          const SizedBox(height: 18),
                          const Text('Nothing here yet',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 6),
                          const Text('Tap "New task" to get started',
                              style: TextStyle(color: AppColors.dim)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                      itemCount: visible.length,
                      itemBuilder: (_, i) {
                        final todo = visible[i];
                        return TweenAnimationBuilder<double>(
                          key: ObjectKey(todo),
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 350),
                          builder: (_, v, child) => Opacity(
                            opacity: v,
                            child: Transform.translate(
                                offset: Offset(0, 20 * (1 - v)), child: child),
                          ),
                          child: TodoCard(
                            todo: todo,
                            onToggle: () => _toggle(todo),
                            onDelete: () => _remove(todo),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
