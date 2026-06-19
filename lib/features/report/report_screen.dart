import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import 'trace_map_widget.dart';

/// Renders the TraumaTrace report: sections A (stress landscape), framing,
/// B/D (patterns + trace maps), C (related concepts), E (reflection), F (strengths).
class ReportScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  const ReportScreen({super.key, required this.report});

  Map<String, dynamic> get payload => report['reportPayload'];

  @override
  Widget build(BuildContext context) {
    final landscape = payload['currentStressLandscape'];
    final patterns = (payload['patterns'] as List?) ?? [];
    final concepts = (payload['relatedConcepts'] as List?) ?? [];
    final quiet = payload['quietResult'];

    return Scaffold(
      appBar: AppBar(title: const Text('Your TraumaTrace')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section('Your current stress landscape'),
          Text(landscape['summary'] ?? ''),
          const SizedBox(height: 20),

          if (payload['framing'] != null) Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(payload['framing'], style: const TextStyle(height: 1.4)),
          ),

          if (quiet != null) Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(quiet, style: const TextStyle(height: 1.4)),
          ),

          ...patterns.map((p) => _patternCard(context, p)),

          if (concepts.isNotEmpty) ...[
            const SizedBox(height: 8),
            _section('Concepts that may help explain this'),
            ...concepts.map((c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(c['term'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c['definition']),
                )),
          ],

          const SizedBox(height: 24),
          const Text('This reflection is for self-understanding and education. It is not a diagnosis.',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _patternCard(BuildContext context, Map<String, dynamic> p) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p['title'], style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TraceMapWidget(nodes: p['traceMap']['nodes']),
          const SizedBox(height: 20),

          _label(context, 'Strengths this gave you'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in (p['strengths'] as List))
              Chip(label: Text(s), visualDensity: VisualDensity.compact),
          ]),
          const SizedBox(height: 16),

          _label(context, 'Where this can go'),
          Text(p['future']),
          const SizedBox(height: 16),

          _label(context, 'A question to sit with'),
          Text(p['reflection'], style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('Reflect'),
              onPressed: () => _reflect(context, p),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _reflect(BuildContext context, Map<String, dynamic> p) async {
    final controller = TextEditingController();
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p['reflection'], style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(controller: controller, maxLines: 5, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write freely...')),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save reflection')),
          const SizedBox(height: 20),
        ]),
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      await ApiClient.instance.post('/reflections', {
        'promptKey': p['id'],
        'prompt': p['reflection'],
        'response': controller.text.trim(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to your Reflection History')));
      }
    }
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );

  Widget _label(BuildContext c, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t.toUpperCase(),
            style: TextStyle(fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600, color: Theme.of(c).colorScheme.primary)),
      );
}
