// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../report/report_screen.dart';

/// Drives Step 1 (stressors) -> Step 2 (coping) -> Step 3 (childhood),
/// then submits to the scoring engine and shows the report.
class AssessmentFlow extends StatefulWidget {
  const AssessmentFlow({super.key});
  @override
  State<AssessmentFlow> createState() => _AssessmentFlowState();
}

class _AssessmentFlowState extends State<AssessmentFlow> {
  Map<String, dynamic>? _content;
  String? _error;
  int _step = 0;
  bool _submitting = false;

  // collected answers
  final Set<String> _stressors = {};
  final Map<String, String> _coping = {}; // questionId -> answerId
  final Map<String, bool> _childhood = {}; // questionId -> yes/no

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ApiClient.instance.get('/assessments/content');
      setState(() => _content = data);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  List get _coping_questions => _content!['copingQuestions'];
  List get _childhood_questions => _content!['childhood']['questions'];

  bool get _canAdvance {
    switch (_step) {
      case 0: return _stressors.isNotEmpty;
      case 1: return _coping.length == _coping_questions.length;
      case 2: return _childhood.length == _childhood_questions.length;
      default: return false;
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final report = await ApiClient.instance.post('/assessments/submit', {
        'stressorIds': _stressors.toList(),
        'copingAnswerIds': _coping.values.toList(),
        'childhoodAnswers': _childhood,
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ReportScreen(report: report)),
      );
    } catch (e) {
      setState(() { _error = e.toString(); _submitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(_error!)));
    }
    if (_content == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(['Current stressors', 'Mood & coping', 'Early experiences'][_step]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_step + 1) / 3),
        ),
      ),
      body: SafeArea(child: _buildStep()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          if (_step > 0)
            TextButton(onPressed: () => setState(() => _step--), child: const Text('Back')),
          const Spacer(),
          FilledButton(
            onPressed: !_canAdvance || _submitting
                ? null
                : () {
                    if (_step < 2) {
                      setState(() => _step++);
                    } else {
                      _submit();
                    }
                  },
            child: _submitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_step < 2 ? 'Continue' : 'See my report'),
          ),
        ]),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _stressorStep();
      case 1: return _copingStep();
      default: return _childhoodStep();
    }
  }

  // Step 1
  Widget _stressorStep() {
    final stressors = _content!['stressors'] as List;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('What is a source of stress in your life right now? Select all that apply.'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10, runSpacing: 10,
          children: stressors.map((s) {
            final id = s['id'];
            final sel = _stressors.contains(id);
            return FilterChip(
              label: Text(s['label']),
              selected: sel,
              onSelected: (v) => setState(() => v ? _stressors.add(id) : _stressors.remove(id)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 2
  Widget _copingStep() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _coping_questions.length,
      itemBuilder: (_, i) {
        final q = _coping_questions[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(q['prompt'], style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...(q['options'] as List).map((o) => RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(o['label']),
                    value: o['id'],
                    groupValue: _coping[q['id']],
                    onChanged: (v) => setState(() => _coping[q['id']] = v!),
                  )),
            ]),
          ),
        );
      },
    );
  }

  // Step 3
  Widget _childhoodStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(_content!['childhood']['intro']),
        ),
        const SizedBox(height: 16),
        ..._childhood_questions.map((q) {
          final id = q['id'];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(q['prompt']),
                const SizedBox(height: 8),
                Row(children: [
                  _yn(id, true, 'Yes'),
                  const SizedBox(width: 8),
                  _yn(id, false, 'No'),
                ]),
              ]),
            ),
          );
        }),
        const SizedBox(height: 8),
        const Text('You can stop at any time. There are no wrong answers.',
            style: TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }

  Widget _yn(String id, bool value, String label) {
    final sel = _childhood[id] == value;
    return ChoiceChip(
      label: Text(label),
      selected: sel,
      onSelected: (_) => setState(() => _childhood[id] = value),
    );
  }
}
