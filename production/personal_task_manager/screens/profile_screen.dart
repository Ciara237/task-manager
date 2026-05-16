import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<_GoalItem> _goals = <_GoalItem>[
    _GoalItem(
      title: 'Maintain Excellent Grades',
      subtitle:
          'Stay consistent with deadlines, projects, and exam preparation.',
      dueLine: 'Due: May 30, 2026',
      badge: 'Academic',
      status: _GoalStatus.completed,
    ),
    _GoalItem(
      title: 'Secure a Summer Internship',
      subtitle:
          'Gathering requirements and building a portfolio.',
      dueLine: 'Due: July 15, 2026',
      badge: 'Career',
      status: _GoalStatus.pending,
    ),
    _GoalItem(
      title: 'Complete my Final Year Project',
      subtitle:
          'Implementing an AI–IoT–blockchain based maternal vital signs monitoring system.',
      dueLine: 'Due: June 20, 2026',
      badge: 'Academic',
      status: _GoalStatus.inProgress,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const BrandedAppTitle('FocusPath'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            tooltip: 'More',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 112,
              height: 112,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned.fill(
                    child: CircleAvatar(
                      backgroundColor: AppColors.mintChip,
                      child: Text(
                        'CF',
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ciara Fomunung',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.headlineNavy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardStroke),
                ),
                child: Text(
                  'ID: LMUI250690',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.bodyGrey,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mintChip,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'BTech. Software Engineering',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Passionate about cybersecurity and AI. Currently focused on building '
            'a personal portfolio and improving problem-solving skills. '
            'I also love to travel and explore new places.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.bodyGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Semester Goals',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.headlineNavy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '2nd Semester, 2026',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.labelCaps,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  for (int i = 0; i < _goals.length; i++) ...<Widget>[
                    if (i > 0) const SizedBox(height: 10),
                    _GoalTile(goal: _goals[i]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _GoalStatus { completed, inProgress, pending }

class _GoalItem {
  const _GoalItem({
    required this.title,
    required this.subtitle,
    required this.dueLine,
    required this.badge,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String dueLine;
  final String badge;
  final _GoalStatus status;
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final _GoalItem goal;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    late final IconData statusIcon;
    late final Color statusColor;

    switch (goal.status) {
      case _GoalStatus.completed:
        statusIcon = Icons.check_circle;
        statusColor = AppColors.primaryDark;
        break;
      case _GoalStatus.inProgress:
        statusIcon = Icons.pending_outlined;
        statusColor = AppColors.bodyGrey;
        break;
      case _GoalStatus.pending:
        statusIcon = Icons.radio_button_unchecked;
        statusColor = AppColors.bodyGrey;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 4,
              color: AppColors.teal,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(statusIcon, color: statusColor, size: 24),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            goal.title,
                            style: textTheme.titleSmall?.copyWith(
                              color: AppColors.headlineNavy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            goal.dueLine,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.bodyGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            goal.subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.bodyGrey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cardStroke),
                          ),
                          child: Text(
                            goal.badge,
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.bodyGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
