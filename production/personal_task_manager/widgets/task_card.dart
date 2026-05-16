import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onDismissed,
    required this.onTap,
  });

  final Task task;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  static bool _isOverdue(Task task) {
    if (task.isCompleted) return false;
    final DateTime now = DateTime.now();
    return DateUtils.dateOnly(task.dueDate).isBefore(DateUtils.dateOnly(now));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color priBg = priorityBadgeBackground(task.priority);
    final Color priFg = priorityBadgeForeground(task.priority);
    final bool overdue = _isOverdue(task);
    final bool done = task.isCompleted;

    final Color titleColor =
        done ? AppColors.bodyGrey : AppColors.headlineNavy;
    final Color muted = AppColors.bodyGrey;

    return Dismissible(
      key: key ??
          ValueKey<String>(
            '${task.title}-${task.dueDate.millisecondsSinceEpoch}',
          ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: priorityColorFor('High'),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Icon(
                    done
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: done ? AppColors.teal : AppColors.bodyGrey,
                    size: 26,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              task.title,
                              style: textTheme.titleMedium?.copyWith(
                                decoration: done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: titleColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.pageBackground
                                  : priBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: done
                                    ? AppColors.cardStroke
                                    : priFg.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              task.priority,
                              style: textTheme.labelSmall?.copyWith(
                                color: done ? muted : priFg,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pageBackground,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.cardStroke),
                            ),
                            child: Text(
                              task.category.toUpperCase(),
                              style: textTheme.labelSmall?.copyWith(
                                color: muted,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                overdue && !done
                                    ? Icons.event_busy
                                    : Icons.calendar_today_outlined,
                                size: 15,
                                color: overdue && !done
                                    ? priorityColorFor('High')
                                    : muted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                overdue && !done
                                    ? 'Overdue: ${MaterialLocalizations.of(context).formatShortDate(task.dueDate)}'
                                    : 'Due: ${MaterialLocalizations.of(context).formatShortDate(task.dueDate)}',
                                style: textTheme.labelMedium?.copyWith(
                                  color: overdue && !done
                                      ? priorityColorFor('High')
                                      : muted,
                                  fontWeight: overdue && !done
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
