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

  void _openAddTaskSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: _AddTaskSheet(
            onSave: (Task task) {
              setState(() => _tasks.add(task));
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> visible = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        child: const Icon(Icons.add),
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
              'Try another filter or tap + to add a task.',
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

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet({required this.onSave});

  final ValueChanged<Task> onSave;

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  static const List<String> _categories = <String>[
    'School',
    'Personal',
    'Health',
  ];
  static const List<String> _priorities = <String>[
    'High',
    'Medium',
    'Low',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<DateTime>> _dueDateFieldKey =
      GlobalKey<FormFieldState<DateTime>>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _category;
  String? _priority;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final DateTime initial = _dueDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
      _dueDateFieldKey.currentState?.didChange(picked);
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final Task task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      priority: _priority!,
      dueDate: _dueDate!,
      isCompleted: false,
    );
    widget.onSave(task);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations loc = MaterialLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category, // ignore: deprecated_member_use
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (String c) => DropdownMenuItem<String>(
                        value: c,
                        child: Text(c),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() => _category = value);
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority, // ignore: deprecated_member_use
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: _priorities
                    .map(
                      (String p) => DropdownMenuItem<String>(
                        value: p,
                        child: Text(p),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() => _priority = value);
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormField<DateTime>(
                key: _dueDateFieldKey,
                initialValue: null,
                validator: (DateTime? value) {
                  if (value == null) {
                    return 'Required';
                  }
                  return null;
                },
                builder: (FormFieldState<DateTime> field) {
                  return InkWell(
                    onTap: _pickDueDate,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Due date',
                        border: const OutlineInputBorder(),
                        errorText: field.errorText,
                      ),
                      child: Text(
                        _dueDate == null
                            ? 'Tap to select due date'
                            : loc.formatMediumDate(_dueDate!),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
