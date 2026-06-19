import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../report/report_screen.dart';
import 'journal_screen.dart';

/// Progress tab — the user's private space:
///   • Today / a gentle daily Motivation Card
///   • My Reports        (GET /reports)
///   • Journal           (free writing)
///   • Reflection History (GET /reflections)
class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});
  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  // Local rotation of gentle prompts shown as the daily Motivation Card.
  // (Push-delivered cards arrive via FCM; this is the in-app surface.)
  static const _motivations = [
    'Noticing a pattern is not the same as being trapped by it.',
    'You are allowed to rest before you have earned it.',
    'The strategies that protected you once are allowed to change.',
    'Curiosity about yourself is a form of kindness.',
    'Small, steady attention changes more than sudden effort.',
    'You can hold compassion for your past self and still grow.',
    'Feeling settled today is worth noticing, not distrusting.',
  ];

  String get _todayMotivation {
    final i = DateTime.now().day % _motivations.length;
    return _motivations[i];
  }

  String get _todayLabel {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Today + Motivation Card ---
          Text(_todayLabel,
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primaryContainer, scheme.secondaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.wb_sunny_outlined, size: 18, color: scheme.onPrimaryContainer),
                    const SizedBox(width: 6),
                    Text('Today’s card',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: scheme.onPrimaryContainer)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(_todayMotivation,
                    style: TextStyle(
                        fontSize: 17, height: 1.4, color: scheme.onPrimaryContainer)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _navTile(
            context,
            icon: Icons.description_outlined,
            title: 'My Reports',
            subtitle: 'Revisit the reflections you have generated.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyReportsScreen()),
            ),
          ),
          _navTile(
            context,
            icon: Icons.edit_note_outlined,
            title: 'Journal',
            subtitle: 'A private space to write freely.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const JournalScreen()),
            ),
          ),
          _navTile(
            context,
            icon: Icons.history_outlined,
            title: 'Reflection History',
            subtitle: 'The questions you have sat with over time.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReflectionHistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// My Reports
// ---------------------------------------------------------------------------
class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  List<dynamic> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient.instance.get('/reports');
      setState(() => _reports = (res as List?) ?? []);
    } catch (_) {
      setState(() => _reports = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _dateLabel(String? iso) {
    if (iso == null) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No reflections yet.\nUse “Explore Myself” on the Home tab to create one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.4, color: Colors.black54),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reports.length,
                    itemBuilder: (context, i) {
                      final r = _reports[i] as Map<String, dynamic>;
                      final payload = (r['reportPayload'] as Map<String, dynamic>?) ?? {};
                      final patterns = (payload['patterns'] as List?) ?? [];
                      final titles = patterns
                          .map((p) => (p as Map)['title']?.toString() ?? '')
                          .where((t) => t.isNotEmpty)
                          .toList();
                      final summary = patterns.isEmpty
                          ? 'A quiet reflection'
                          : titles.join(' · ');
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          title: Text(summary,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(_dateLabel(r['createdAt']?.toString())),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ReportScreen(report: r)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reflection History
// ---------------------------------------------------------------------------
class ReflectionHistoryScreen extends StatefulWidget {
  const ReflectionHistoryScreen({super.key});
  @override
  State<ReflectionHistoryScreen> createState() => _ReflectionHistoryScreenState();
}

class _ReflectionHistoryScreenState extends State<ReflectionHistoryScreen> {
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient.instance.get('/reflections');
      setState(() => _items = (res as List?) ?? []);
    } catch (_) {
      setState(() => _items = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reflection History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No reflections saved yet.\nAnswer a reflection question in a report to keep it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.4, color: Colors.black54),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final r = _items[i] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r['prompt'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, height: 1.4)),
                              const SizedBox(height: 8),
                              Text(r['response'] ?? '',
                                  style: const TextStyle(height: 1.5)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
