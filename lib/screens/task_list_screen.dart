import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';

enum _TaskFilter { all, pending, completed }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  _TaskFilter _filter = _TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _tasks = <Task>[
      Task(
        title: 'Submit project report',
        description: 'First three chapters',
        category: 'School',
        priority: 'High',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: false,
      ),
      Task(
        title: 'Complete Practical Ethical Hacker Course',
        description: 'Complete all modules and practice on HacktheBox.',
        category: 'Personal',
        priority: 'Medium',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        isCompleted: false,
      ),
      Task(
        title: 'Complete Supervision Fee',
        description: 'Avoid late payment.',
        category: 'Personal',
        priority: 'Low',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        isCompleted: true,
      ),
      Task(
        title: 'Practice Flutter widgets',
        description: 'Build two todo app exercises and push code to Github.',
        category: 'Learning',
        priority: 'Medium',
        dueDate: DateTime.now(),
        isCompleted: false,
      ),
    ];
  }

  List<Task> get _filteredTasks {
    switch (_filter) {
      case _TaskFilter.all:
        return List<Task>.from(_tasks);
      case _TaskFilter.pending:
        return _tasks.where((Task t) => !t.isCompleted).toList();
      case _TaskFilter.completed:
        return _tasks.where((Task t) => t.isCompleted).toList();
    }
  }

  int get _total => _tasks.length;
  int get _completed => _tasks.where((Task t) => t.isCompleted).length;
  int get _pending => _tasks.where((Task t) => !t.isCompleted).length;

  double get _progressValue =>
      _total == 0 ? 0.0 : _completed / _total;

  void _setFilter(_TaskFilter value) {
    setState(() => _filter = value);
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> visible = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _StatsBar(
              total: _total,
              pending: _pending,
              completed: _completed,
              progress: _progressValue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _FilterRow(
              filter: _filter,
              onChanged: _setFilter,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: visible.isEmpty
                ? const _TaskListEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: visible.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Task task = visible[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index > 0) const Divider(height: 1),
                          TaskCard(
                            key: ValueKey<String>(
                              '${task.title}-${task.dueDate.millisecondsSinceEpoch}-$index',
                            ),
                            task: task,
                            onDismissed: () {
                              setState(() {
                                _tasks.remove(task);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({
    required this.total,
    required this.pending,
    required this.completed,
    required this.progress,
  });

  final int total;
  final int pending;
  final int completed;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: $total', style: textTheme.titleSmall),
                Text('Pending: $pending', style: textTheme.bodyMedium),
                Text('Done: $completed', style: textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Completion',
              style: textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filter,
    required this.onChanged,
  });

  final _TaskFilter filter;
  final ValueChanged<_TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChip(
            label: 'All',
            selected: filter == _TaskFilter.all,
            onTap: () => onChanged(_TaskFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterChip(
            label: 'Pending',
            selected: filter == _TaskFilter.pending,
            onTap: () => onChanged(_TaskFilter.pending),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterChip(
            label: 'Completed',
            selected: filter == _TaskFilter.completed,
            onTap: () => onChanged(_TaskFilter.completed),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskListEmptyState extends StatelessWidget {
  const _TaskListEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks here',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try another filter or add tasks when that feature is ready.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
