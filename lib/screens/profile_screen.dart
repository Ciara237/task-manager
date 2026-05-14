import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<_GoalItem> _goals = <_GoalItem>[
    _GoalItem(
      title: 'Maintain Excellent Grades',
      subtitle:
          'Targeting a 3.9 semester GPA as a personal goal.',
      status: _GoalStatus.completed,
    ),
    _GoalItem(
      title: 'Secure a Summer Internship',
      subtitle:
          'Gathering requirements and building a portfolio.',
      status: _GoalStatus.inProgress,
    ),
    _GoalItem(
      title: 'Complete my Final Year Project',
      subtitle:
          'Implementing an AI–IoT–blockchain based maternal vital signs monitoring system.',
      status: _GoalStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('FocusPath'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
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
          const SizedBox(height: 8),
          Text(
            'ID: LMUI250690 · BTech. Software Engineering',
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.labelCaps,
              letterSpacing: 0.5,
              height: 1.35,
            ),
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
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'SEMESTER GOALS',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.labelCaps,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mintChip,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '2nd Semester, 2026',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  for (int i = 0; i < _goals.length; i++) ...<Widget>[
                    if (i > 0) ...<Widget>[
                      const Divider(height: 24, color: AppColors.cardStroke),
                    ],
                    _GoalRow(goal: _goals[i]),
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
    required this.status,
  });

  final String title;
  final String subtitle;
  final _GoalStatus status;
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.goal});

  final _GoalItem goal;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    late final IconData icon;
    late final Color iconColor;

    switch (goal.status) {
      case _GoalStatus.completed:
        icon = Icons.check_circle;
        iconColor = AppColors.primaryDark;
        break;
      case _GoalStatus.inProgress:
        icon = Icons.pending_outlined;
        iconColor = AppColors.bodyGrey;
        break;
      case _GoalStatus.pending:
        icon = Icons.radio_button_unchecked;
        iconColor = AppColors.bodyGrey;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                goal.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.bodyGrey,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
