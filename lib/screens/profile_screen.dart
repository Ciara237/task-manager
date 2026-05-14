import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF1B6B3A);
    const Color lightGreen = Color(0xFFD6F5E3);
    const Color greyText = Color(0xFF757575);

    final List<Map<String, dynamic>> goals = [
      {
        'title': 'Maintain Excellent Grades',
        'subtitle': "Targeting a 3.9 semester GPA as a personal goal.",
        'isDone': false,
      },
      {
        'title': 'Secure a Summer Internship',
        'subtitle': 'Gathering Requirements and Building a Portfolio.',
        'isDone': false,
      },
      {
        'title': 'Complete my Final Year Project',
        'subtitle': 'Implementing an AI-IOT-Blockchain based maternal Vital Signs Monitoring System.',
        'isDone': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            const CircleAvatar(
              radius: 48,
              backgroundColor: lightGreen,
              child: Text(
                'CF',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            const Text(
              'Ciara Fomunung',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // ID and programme
            const Text(
              'ID: LMUI250690  •  BTech. Software Engineering',
              style: TextStyle(fontSize: 12, color: greyText, letterSpacing: 0.5),
            ),
            const SizedBox(height: 16),

            // Bio
            const Text(
              'Passionate about Cybersecurity and AI. '
              'Currently focused on building a personal portfolio and improving my problem-solving skills. . '
              'Also, I love to travel and explore new places.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: greyText, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Goals card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SEMESTER GOALS',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          color: greyText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '2nd Semester, 2026',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Goals list
                  for (int i = 0; i < goals.length; i++) ...[
                    if (i > 0) const Divider(color: Color(0xFFE0E0E0)),
                    if (i > 0) const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          goals[i]['isDone'] ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: primaryGreen,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goals[i]['title'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                goals[i]['subtitle'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: greyText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}