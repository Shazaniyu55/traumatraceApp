import 'package:flutter/material.dart';
import '../assessment/assessment_flow.dart';

class ExploreIntroScreen extends StatelessWidget {
  const ExploreIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.volume_off, 'Find a quiet place'),
      (Icons.timer_outlined, 'Allow 20–30 uninterrupted minutes'),
      (Icons.notifications_off_outlined, 'Turn off notifications'),
      (Icons.headphones, 'Use headphones if desired'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Before you begin')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('A short note before we start',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...items.map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Icon(i.$1, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(child: Text(i.$2, style: Theme.of(context).textTheme.bodyLarge)),
                    ]),
                  )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AssessmentFlow()),
                  ),
                  child: const Text("I'm ready"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
