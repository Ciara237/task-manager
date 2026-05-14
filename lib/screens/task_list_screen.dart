import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import '../theme/priority_colors.dart';
import '../widgets/task_card.dart';
import '../widgets/task_editor_sheet.dart';
import 'task_detail_screen.dart';

enum _TaskFilter { all, pending, completed }

enum _TaskSort { dueDate, priority }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  _TaskFilter _filter = _TaskFilter.all;
  _TaskSort _sort = _TaskSort.dueDate;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Task> get _baseFiltered {
    switch (_filter) {
      case _TaskFilter.all:
        return List<Task>.from(_tasks);
      case _TaskFilter.pending:
        return _tasks.where((Task t) => !t.isCompleted).toList();
      case _TaskFilter.completed:
        return _tasks.where((Task t) => t.isCompleted).toList();
    }
  }

  List<Task> get _afterSearch {
    final List<Task> base = _baseFiltered;
    final String q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return List<Task>.from(base);
    }
    return base
        .where((Task t) => t.title.toLowerCase().contains(q))
        .toList();
  }

  List<Task> get _displayTasks {
    final List<Task> list = List<Task>.from(_afterSearch);
    switch (_sort) {
      case _TaskSort.dueDate:
        list.sort((Task a, Task b) => a.dueDate.compareTo(b.dueDate));
        break;
      case _TaskSort.priority:
        list.sort((Task a, Task b) {
          final int c = prioritySortKey(a.priority)
              .compareTo(prioritySortKey(b.priority));
          if (c != 0) {
            return c;
          }
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
    }
    return list;
  }

  int get _total => _tasks.length;
  int get _completed => _tasks.where((Task t) => t.isCompleted).length;
  int get _pending => _tasks.where((Task t) => !t.isCompleted).length;

  double get _progressValue => _total == 0 ? 0.0 : _completed / _total;

  void _setFilter(_TaskFilter value) {
    setState(() => _filter = value);
  }

  void _stopSearching() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  Future<void> _showSortDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Sort by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<_TaskSort>(
                title: const Text('Due date (earliest first)'),
                value: _TaskSort.dueDate,
                groupValue: _sort,
                onChanged: (_TaskSort? value) {
                  if (value != null) {
                    setState(() => _sort = value);
                  }
                  Navigator.of(ctx).pop();
                },
              ),
              RadioListTile<_TaskSort>(
                title: const Text('Priority (High → Medium → Low)'),
                value: _TaskSort.priority,
                groupValue: _sort,
                onChanged: (_TaskSort? value) {
                  if (value != null) {
                    setState(() => _sort = value);
                  }
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmClearAll() async {
    if (_tasks.isEmpty) {
      return;
    }
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Clear all tasks?'),
          content: const Text('This will remove every task. This cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete all'),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      setState(_tasks.clear);
    }
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
          child: TaskEditorSheet(
            onSave: (Task task) {
              setState(() => _tasks.add(task));
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _openTaskDetail(Task task, int taskIndex) async {
    final TaskDetailPopResult? result =
        await Navigator.of(context).push<TaskDetailPopResult?>(
      MaterialPageRoute<TaskDetailPopResult?>(
        settings: RouteSettings(
          arguments: TaskDetailArguments(task: task, taskIndex: taskIndex),
        ),
        builder: (BuildContext ctx) {
          final Object? args = ModalRoute.of(ctx)!.settings.arguments;
          final TaskDetailArguments td = args! as TaskDetailArguments;
          return TaskDetailScreen(
            task: td.task,
            taskIndex: td.taskIndex,
          );
        },
      ),
    );
    if (!mounted || result == null) {
      return;
    }
    if (result.deleted) {
      setState(() {
        if (result.taskIndex >= 0 && result.taskIndex < _tasks.length) {
          _tasks.removeAt(result.taskIndex);
        }
      });
      return;
    }
    if (result.task != null) {
      setState(() {
        if (result.taskIndex >= 0 && result.taskIndex < _tasks.length) {
          _tasks[result.taskIndex] = result.task!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> visible = _displayTasks;
    final bool emptyFromSearch = visible.isEmpty &&
        _baseFiltered.isNotEmpty &&
        _searchQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _stopSearching,
                tooltip: 'Close search',
              )
            : null,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Filter by title',
                  border: InputBorder.none,
                  isDense: true,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (String value) {
                  setState(() => _searchQuery = value);
                },
              )
            : const Text('TaskFlow'),
        actions: _isSearching
            ? null
            : <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {
                    setState(() => _isSearching = true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort',
                  onPressed: _showSortDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Clear all tasks',
                  onPressed: _confirmClearAll,
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: visible.isEmpty
                  ? _TaskListEmptyState(
                      emptyFromSearch: emptyFromSearch,
                    )
                  : Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: visible.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final Task task = visible[index];
                            final int taskIndex = _tasks.indexWhere(
                              (Task t) => identical(t, task),
                            );
                            return TaskCard(
                              key: ValueKey<String>(
                                '${task.title}-${task.dueDate.millisecondsSinceEpoch}-$index',
                              ),
                              task: task,
                              onTap: () {
                                if (taskIndex >= 0) {
                                  _openTaskDetail(task, taskIndex);
                                }
                              },
                              onDismissed: () {
                                setState(() {
                                  _tasks.removeWhere((Task t) => identical(t, task));
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
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
    final int pct = (progress * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _StatColumn(
                    label: 'TOTAL',
                    value: '$total',
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'PENDING',
                    value: pending.toString().padLeft(2, '0'),
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'COMPLETED',
                    value: '$completed',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$pct% DONE',
                style: const TextStyle(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total == 0 ? 0.0 : progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.cardStroke,
                color: AppColors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.headlineNavy,
              ),
        ),
      ],
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
      children: <Widget>[
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
    return Material(
      color: selected ? AppColors.mintChip : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: selected ? AppColors.teal : AppColors.cardStroke,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? AppColors.primaryDark : AppColors.bodyGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskListEmptyState extends StatelessWidget {
  const _TaskListEmptyState({required this.emptyFromSearch});

  final bool emptyFromSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              emptyFromSearch ? Icons.search_off : Icons.inbox_outlined,
              size: 72,
              color: AppColors.bodyGrey.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 16),
            Text(
              emptyFromSearch ? 'No matching tasks' : 'No tasks here',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.headlineNavy,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              emptyFromSearch
                  ? 'Try a different search or clear the filter.'
                  : 'Try another filter or tap + to add a task.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.bodyGrey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
