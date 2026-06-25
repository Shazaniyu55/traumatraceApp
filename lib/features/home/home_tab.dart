// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/core/helper/navigator.dart';
import 'package:trauma/features/home/profile.dart';
import 'package:trauma/features/progress/journal_screen.dart';
import 'explore_intro_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const String? _photoUrl = null;
  static const String _name = 'Jordan';
  static const String _dateLabel = 'Monday, Jun 22';

  // Sample data — replace with real values later.
  static const int _moodStreak = 7;      // days
  static const int _reflectionsToday = 2;
  static const int _reflectionGoal = 3;
  static const int _journalMinutes = 18;
  static const int _journalGoal = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEF8),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(name: _name, dateLabel: _dateLabel, photoUrl: _photoUrl),
              const SizedBox(height: 20),
              const _SummaryCard(
                moodStreak: _moodStreak,
                reflectionsToday: _reflectionsToday,
                reflectionGoal: _reflectionGoal,
                journalMinutes: _journalMinutes,
                journalGoal: _journalGoal,
              ),
              const SizedBox(height: 16),
              const _QuickActions(),
              const SizedBox(height: 24),
              const Text(
                "Today's activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15182B),
                ),
              ),
              const SizedBox(height: 12),
              const _ActivityRow(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Up next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF15182B),
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _UpNextCard(),
              const SizedBox(height: 12),
              const Text(
                'TraumaTrace is for reflection and education. It does not diagnose or provide therapy.',
                style: TextStyle(fontSize: 11, color: Color(0xFF8A8F9C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.dateLabel,
    required this.photoUrl,
  });
  final String name;
  final String dateLabel;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                style: const TextStyle(fontSize: 13, color: Color(0xFF8A8F9C)),
              ),
              const SizedBox(height: 2),
              Text(
                'Hey, $name 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15182B),
                ),
              ),
            ],
          ),
        ),
        _CircleButton(
          onTap: () {},
          background: Colors.white,
          child: const Icon(Icons.notifications_none_rounded,
              size: 22, color: Color(0xFF15182B)),
        ),
        const SizedBox(width: 10),
        _CircleButton(
          onTap: () => changeScreenReplacement(context, ProfileScreen()),
          background: primaryColor,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.child,
    required this.background,
    required this.onTap,
  });
  final Widget child;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3)),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ── Summary card ────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.moodStreak,
    required this.reflectionsToday,
    required this.reflectionGoal,
    required this.journalMinutes,
    required this.journalGoal,
  });
  final int moodStreak;
  final int reflectionsToday;
  final int reflectionGoal;
  final int journalMinutes;
  final int journalGoal;

  @override
  Widget build(BuildContext context) {
    final reflectProgress =
        reflectionGoal == 0 ? 0.0 : (reflectionsToday / reflectionGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _RingProgress(
                progress: reflectProgress,
                centerValue: reflectionsToday,
                centerLabel: 'reflections',
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _StatLine(
                      icon: Icons.local_fire_department_rounded,
                      color: const Color(0xFFF15B40),
                      value: moodStreak,
                      label: 'Day streak',
                    ),
                    const SizedBox(height: 14),
                    _StatLine(
                      icon: Icons.self_improvement_rounded,
                      color: const Color(0xFF12B76A),
                      value: reflectionsToday,
                      label: 'Reflections',
                    ),
                    const SizedBox(height: 14),
                    _StatLine(
                      icon: Icons.adjust_rounded,
                      color: primaryColor,
                      value: reflectionGoal,
                      label: 'Daily goal',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ProgressBar(
                  label: 'Journal',
                  value: journalMinutes,
                  total: journalGoal,
                  unit: 'min',
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ProgressBar(
                  label: 'Patterns',
                  value: 3,
                  total: 5,
                  unit: 'found',
                  color: const Color(0xFF9B59E0),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ProgressBar(
                  label: 'Mood',
                  value: 4,
                  total: 5,
                  unit: 'logged',
                  color: const Color(0xFF12B76A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingProgress extends StatelessWidget {
  const _RingProgress({
    required this.progress,
    required this.centerValue,
    required this.centerLabel,
  });
  final double progress;
  final int centerValue;
  final String centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      height: 116,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 116,
            height: 116,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 11,
              backgroundColor: const Color(0xFFEDEFF4),
              valueColor: AlwaysStoppedAnimation(primaryColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$centerValue',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15182B),
                ),
              ),
              Text(
                centerLabel,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8A8F9C)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withAlpha(28),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF15182B),
              ),
            ),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Color(0xFF8A8F9C))),
          ],
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.label,
    required this.value,
    required this.total,
    required this.unit,
    required this.color,
  });
  final String label;
  final int value;
  final int total;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : (value / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15182B),
                ),
              ),
              TextSpan(
                text: '  $value/$total $unit',
                style:
                    const TextStyle(fontSize: 11, color: Color(0xFF8A8F9C)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: const Color(0xFFEDEFF4),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ── Quick actions ────────────────────────────────────────────────────────
class _QuickActions extends StatefulWidget {
  const _QuickActions();

  @override
  State<_QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<_QuickActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _ActionTile(
                icon: Icons.edit_note_rounded, label: 'Journal', onTap: (){
                  changeScreenReplacement(context, JournalScreen());
                })),
        const SizedBox(width: 12),
        Expanded(
            child: _ActionTile(
                icon: Icons.self_improvement_rounded,
                label: 'Reflect', onTap: (){})),
        const SizedBox(width: 12),
        Expanded(
            child: _ActionTile(
                icon: Icons.mood_rounded, label: 'Log Mood', onTap: (){})),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap; // ← fix the type

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // ← wrap with this
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(28),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15182B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Today's activity ─────────────────────────────────────────────────────
class _ActivityRow extends StatelessWidget {
  const _ActivityRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _StreakCard(streak: 7, goal: 14)),
        SizedBox(width: 14),
        Expanded(child: _BreathCard(sessions: 2, goalSessions: 3)),
      ],
    );
  }
}

class _ActivityShell extends StatelessWidget {
  const _ActivityShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak, required this.goal});
  final int streak;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final pct = (streak / goal).clamp(0.0, 1.0);
    return _ActivityShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(28),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.local_fire_department_rounded,
                color: primaryColor, size: 19),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF15182B)),
          ),
          Text(
            'of $goal day streak',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F9C)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0xFFEDEFF4),
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathCard extends StatelessWidget {
  const _BreathCard({required this.sessions, required this.goalSessions});
  final int sessions;
  final int goalSessions;

  @override
  Widget build(BuildContext context) {
    return _ActivityShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F4F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.air_rounded,
                    color: Color(0xFF12B76A), size: 18),
              ),
              const Spacer(),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF12B76A),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '2',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF15182B)),
                ),
                TextSpan(
                  text: ' sessions',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A8F9C)),
                ),
              ],
            ),
          ),
          Text(
            '$sessions of $goalSessions breathing',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F9C)),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(goalSessions, (i) {
              final filled = i < sessions;
              return Container(
                width: 12,
                height: 12,
                margin:
                    EdgeInsets.only(right: i == goalSessions - 1 ? 0 : 5),
                decoration: BoxDecoration(
                  color: filled
                      ? const Color(0xFF12B76A)
                      : const Color(0xFFE3E7EE),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Up next ──────────────────────────────────────────────────────────────
class _UpNextCard extends StatelessWidget {
  const _UpNextCard();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ExploreIntroScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B4EFF), Color(0xFF8B6FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.self_improvement_rounded,
                  color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Myself',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '20–30 min · Guided reflection',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}



 