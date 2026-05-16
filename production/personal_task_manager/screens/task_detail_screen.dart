import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_editor_sheet.dart';

/// Passed via [RouteSettings.arguments] when pushing [TaskDetailScreen].
class TaskDetailArguments {
  const TaskDetailArguments({
    required this.task,
    required this.taskIndex,
  });

  final Task task;
  final int taskIndex;
}

/// Returned to the task list when leaving the detail screen.
class TaskDetailPopResult {
  const TaskDetailPopResult.updated(this.task, this.taskIndex) : deleted = false;

  const TaskDetailPopResult.deleted(this.taskIndex)
      : task = null,
        deleted = true;

  final Task? task;
  final int taskIndex;
  final bool deleted;
}

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.taskIndex,
  });

  final Task task;
  final int taskIndex;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;
  late int _index;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _index = widget.taskIndex;
  }

  bool _isOverdue(Task task) {
    if (task.isCompleted) return false;
    final DateTime now = DateTime.now();
    return DateUtils.dateOnly(task.dueDate).isBefore(DateUtils.dateOnly(now));
  }

  void _popUpdated() {
    Navigator.of(context).pop(TaskDetailPopResult.updated(_task, _index));
  }

  Future<void> _confirmDelete() async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: const Text('This task will be permanently removed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (ok == true && mounted) {
      Navigator.of(context).pop(TaskDetailPopResult.deleted(_index));
    }
  }

  void _toggleComplete() {
    setState(() {
      _task = _task.copyWith(isCompleted: !_task.isCompleted);
    });
    Navigator.of(context).pop(TaskDetailPopResult.updated(_task, _index));
  }

  void _openEditSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: TaskEditorSheet(
            initialTask: _task,
            onSave: (Task updated) {
              setState(() => _task = updated);
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations loc = MaterialLocalizations.of(context);
    final bool overdue = _isOverdue(_task);
    final Color priBg = priorityBadgeBackground(_task.priority);
    final Color priFg = priorityBadgeForeground(_task.priority);
    final String timeStr = TimeOfDay.fromDateTime(_task.dueDate).format(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && context.mounted) {
          Navigator.of(context).pop(TaskDetailPopResult.updated(_task, _index));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _popUpdated,
          ),
          title: const BrandedAppTitle('FocusPath'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More',
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: <Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _CategoryBadge(label: _task.category.toUpperCase()),
                _PriorityBadge(
                  priority: _task.priority,
                  background: priBg,
                  foreground: priFg,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.headlineNavy,
                    height: 1.2,
                    decoration: _task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.bodyGrey,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  overdue && !_task.isCompleted
                      ? Icons.event_busy
                      : Icons.calendar_today_outlined,
                  size: 18,
                  color: overdue && !_task.isCompleted
                      ? priorityColorFor('High')
                      : AppColors.bodyGrey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: <Widget>[
                      Text(
                        overdue && !_task.isCompleted
                            ? 'Overdue: ${loc.formatMediumDate(_task.dueDate)}'
                            : 'Due ${loc.formatMediumDate(_task.dueDate)}',
                        style: TextStyle(
                          color: overdue && !_task.isCompleted
                              ? priorityColorFor('High')
                              : AppColors.bodyGrey,
                          fontWeight: overdue && !_task.isCompleted
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                      Text(
                        '·',
                        style: TextStyle(
                          color: AppColors.bodyGrey.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.bodyGrey,
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: AppColors.bodyGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Icon(
                  _task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 22,
                  color: _task.isCompleted ? AppColors.teal : AppColors.bodyGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  _task.isCompleted ? 'Completed' : 'In progress',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.headlineNavy,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'DESCRIPTION',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardStroke),
              ),
              child: Text(
                _task.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.headlineNavy,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _toggleComplete,
              icon: Icon(
                _task.isCompleted ? Icons.undo : Icons.check_circle_outline,
                size: 22,
              ),
              label: Text(
                _task.isCompleted ? 'MARK INCOMPLETE' : 'MARK COMPLETE',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openEditSheet,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('EDIT TASK'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: priorityColorFor('High'),
                side: const BorderSide(color: AppColors.cardStroke),
              ),
              icon: Icon(Icons.delete_outline, color: priorityColorFor('High')),
              label: Text(
                'DELETE',
                style: TextStyle(color: priorityColorFor('High')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.bodyGrey,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({
    required this.priority,
    required this.background,
    required this.foreground,
  });

  final String priority;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final bool urgent = priority.toLowerCase() == 'high';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: foreground.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (urgent) ...<Widget>[
            Icon(Icons.priority_high, size: 18, color: foreground),
            const SizedBox(width: 2),
          ],
          Text(
            urgent ? 'URGENT' : priority.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
          ),
        ],
      ),
    );
  }
}
