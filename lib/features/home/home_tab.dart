import 'package:flutter/material.dart';
import 'explore_intro_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Welcome', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'TraumaTrace helps you explore experiences, patterns, and stressors that may have shaped your wellbeing.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.3),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore Myself',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  const Text('A guided 20–30 minute reflection into your stressors, patterns, and early experiences.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ExploreIntroScreen()),
                    ),
                    child: const Text('Begin'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'TraumaTrace is for reflection and education. It does not diagnose or provide therapy.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
