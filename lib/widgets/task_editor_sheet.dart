import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import '../theme/priority_colors.dart';

/// Bottom sheet for creating or editing a task (shared with list and detail flows).
class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    this.initialTask,
    required this.onSave,
  });

  /// When non-null, fields are pre-filled and [isCompleted] is preserved on save.
  final Task? initialTask;
  final ValueChanged<Task> onSave;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  static const List<String> _categories = <String>[
    'School',
    'Personal',
    'Health',
    'Learning',
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

  bool get _isEdit => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final Task? t = widget.initialTask;
    if (t != null) {
      _titleController.text = t.title;
      _descriptionController.text = t.description;
      _category =
          _categories.contains(t.category) ? t.category : _categories.first;
      _priority = t.priority;
      _dueDate = t.dueDate;
    } else {
      _category = _categories.first;
      _priority = _priorities[1];
      _dueDate = DateTime.now();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dueDateFieldKey.currentState?.didChange(_dueDate);
    });
  }

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

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final bool completed = widget.initialTask?.isCompleted ?? false;
    final Task task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      priority: _priority!,
      dueDate: _dueDate!,
      isCompleted: completed,
    );
    widget.onSave(task);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations loc = MaterialLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _isEdit ? 'Edit Task' : 'New Task',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.bodyGrey,
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.cardStroke),
              Text(
                'TASK TITLE',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter task name…',
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
              Text(
                'DESCRIPTION',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Add details or context…',
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
              Text(
                'CATEGORY',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  hintText: 'Select category',
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
              Text(
                'PRIORITY',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  hintText: 'Select priority',
                ),
                items: _priorities
                    .map(
                      (String p) => DropdownMenuItem<String>(
                        value: p,
                        child: Text(
                          p,
                          style: TextStyle(
                            color: priorityColorFor(p),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
              Text(
                'DUE DATE',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              FormField<DateTime>(
                key: _dueDateFieldKey,
                initialValue: _dueDate,
                validator: (DateTime? value) {
                  if (value == null) {
                    return 'Required';
                  }
                  return null;
                },
                builder: (FormFieldState<DateTime> field) {
                  return InkWell(
                    onTap: _pickDueDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Set date',
                        errorText: field.errorText,
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
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
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_outline, size: 22),
                label: Text(_isEdit ? 'SAVE CHANGES' : 'SAVE TASK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
