// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../../core/api_client.dart';

/// Resources tab — three entry points:
///   • Learn & Grow  (educational modules)
///   • Trauma Glossary (searchable)
///   • Find Support  (therapist directory + self-registration)
class ResourcesTab extends StatelessWidget {
  const ResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            context,
            icon: Icons.eco_outlined,
            title: 'Learn & Grow',
            subtitle: 'Short, plain-language modules on how the mind and body carry stress.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LearnGrowScreen()),
            ),
          ),
          _card(
            context,
            icon: Icons.menu_book_outlined,
            title: 'Trauma Glossary',
            subtitle: 'Look up the concepts referenced in your reflections.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GlossaryScreen()),
            ),
          ),
          _card(
            context,
            icon: Icons.handshake_outlined,
            title: 'Find Support',
            subtitle: 'Connect with trauma-informed therapists, or join the directory.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FindSupportScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(height: 1.3)),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Learn & Grow — static educational modules (content can be moved to the API).
// ---------------------------------------------------------------------------
class LearnGrowScreen extends StatelessWidget {
  const LearnGrowScreen({super.key});

  static const _modules = [
    {
      'title': 'The Family Loop',
      'summary':
          'How patterns of relating learned at home can quietly repeat in adult relationships — and how noticing the loop is the first step to changing it.',
      'body':
          'Families pass down more than features. They pass down ways of handling closeness, conflict, and need. '
              'A child who learns that calm only comes after they smooth things over may grow into an adult who keeps the peace at their own expense. '
              'None of this is a flaw — it is an adaptation that once made sense. Seeing the loop clearly is what lets you decide, as an adult, which parts to keep and which to gently set down.',
    },
    {
      'title': 'Gut & Mental Health',
      'summary':
          'Why stress is so often felt in the body first — and what the gut–brain connection means for everyday wellbeing.',
      'body':
          'The gut and brain are in constant conversation through the vagus nerve and a steady stream of chemical signals. '
              'When the nervous system stays braced for a long time, digestion, sleep, and appetite often shift before the mind catches up. '
              'This is why "I just feel off" can be real and physical. Gentle routines — regular meals, movement, rest, slow breathing — are not cures, but they are ways of telling the body it is safe enough to settle.',
    },
    {
      'title': 'Why Patterns Persist',
      'summary':
          'A short look at why old protective habits can outlive the situations that created them.',
      'body':
          'A pattern persists because, at some point, it worked. Staying alert kept someone safe. Achieving brought approval. '
              'Pleasing others reduced conflict. The mind remembers what worked and reaches for it automatically, even years later in safer circumstances. '
              'Understanding this removes the shame: you are not broken or weak — you are running a strategy that has simply outlived its usefulness.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn & Grow')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _modules.length,
        itemBuilder: (context, i) {
          final m = _modules[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ExpansionTile(
              shape: const Border(),
              tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              title: Text(m['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(m['summary']!, style: const TextStyle(height: 1.3)),
              ),
              children: [Text(m['body']!, style: const TextStyle(height: 1.5))],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trauma Glossary — searchable list backed by GET /glossary?q=
// ---------------------------------------------------------------------------
class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});
  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  List<dynamic> _terms = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final path = _query.isEmpty ? '/glossary' : '/glossary?q=${Uri.encodeQueryComponent(_query)}';
      final res = await ApiClient.instance.get(path);
      setState(() => _terms = (res as List?) ?? []);
    } catch (_) {
      setState(() => _terms = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trauma Glossary')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search concepts…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => _query = v,
              onSubmitted: (_) => _load(),
            ),
          ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_terms.isEmpty)
            const Expanded(child: Center(child: Text('No terms found.')))
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _terms.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final t = _terms[i] as Map<String, dynamic>;
                  return ListTile(
                    title: Text(t['term'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(t['definition'] ?? '',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => GlossaryDetailScreen(term: t),
                    )),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class GlossaryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> term;
  const GlossaryDetailScreen({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    final signs = (term['commonSigns'] as List?) ?? [];
    final related = (term['relatedConcepts'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(term['term'] ?? 'Concept')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(term['definition'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4)),
          const SizedBox(height: 16),
          if ((term['description'] ?? '').toString().isNotEmpty)
            Text(term['description'], style: const TextStyle(height: 1.5)),
          if (signs.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Common signs', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            ...signs.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('•  $s', style: const TextStyle(height: 1.4)),
                )),
          ],
          if (related.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Related concepts', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: related
                  .map((r) => Chip(label: Text(r.toString())))
                  .toList(),
            ),
          ],
          if ((term['reflectionQuestion'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('A question to sit with',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(term['reflectionQuestion'], style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Find Support — verified directory (GET /therapists) + self-registration.
// ---------------------------------------------------------------------------
class FindSupportScreen extends StatefulWidget {
  const FindSupportScreen({super.key});
  @override
  State<FindSupportScreen> createState() => _FindSupportScreenState();
}

class _FindSupportScreenState extends State<FindSupportScreen> {
  List<dynamic> _therapists = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient.instance.get('/therapists');
      setState(() => _therapists = (res as List?) ?? []);
    } catch (_) {
      setState(() => _therapists = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Support')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const TherapistRegisterScreen()),
          );
          if (added == true) _load();
        },
        icon: const Icon(Icons.add),
        label: const Text("I'm a therapist"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _therapists.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No therapists listed yet.\nVerified practitioners will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 1.4, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _therapists.length,
                      itemBuilder: (context, i) {
                        final t = _therapists[i] as Map<String, dynamic>;
                        final specialties = (t['specialties'] as List?) ?? [];
                        final location = [t['city'], t['country']]
                            .where((e) => e != null && e.toString().isNotEmpty)
                            .join(', ');
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['fullName'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 16)),
                                if (location.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(location,
                                        style: const TextStyle(color: Colors.black54)),
                                  ),
                                if ((t['bio'] ?? '').toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(t['bio'], style: const TextStyle(height: 1.4)),
                                  ),
                                if (specialties.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: specialties
                                          .map((s) => Chip(
                                                label: Text(s.toString(),
                                                    style: const TextStyle(fontSize: 12)),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize.shrinkWrap,
                                                visualDensity: VisualDensity.compact,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                if ((t['email'] ?? '').toString().isNotEmpty ||
                                    (t['phone'] ?? '').toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      [t['email'], t['phone']]
                                          .where((e) =>
                                              e != null && e.toString().isNotEmpty)
                                          .join('  •  '),
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ),
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

class TherapistRegisterScreen extends StatefulWidget {
  const TherapistRegisterScreen({super.key});
  @override
  State<TherapistRegisterScreen> createState() => _TherapistRegisterScreenState();
}

class _TherapistRegisterScreenState extends State<TherapistRegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _bio = TextEditingController();
  final _specialties = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _city, _country, _bio, _specialties]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required.')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await ApiClient.instance.post('/therapists/register', {
        'fullName': _name.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'city': _city.text.trim(),
        'country': _country.text.trim(),
        'bio': _bio.text.trim(),
        'specialties': _specialties.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Submitted. Your listing will appear once verified.')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not submit: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join the directory')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Listings are reviewed before they go live. We may contact you to verify credentials.',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 16),
          _field(_name, 'Full name *'),
          _field(_email, 'Email *', keyboard: TextInputType.emailAddress),
          _field(_phone, 'Phone', keyboard: TextInputType.phone),
          _field(_city, 'City'),
          _field(_country, 'Country'),
          _field(_specialties, 'Specialties (comma-separated)'),
          _field(_bio, 'Short bio', maxLines: 4),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Submit listing'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {int maxLines = 1, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
