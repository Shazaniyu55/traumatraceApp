// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Visual pathway: pattern -> emotion -> adaptation -> origin.
class TraceMapWidget extends StatelessWidget {
  final Map<String, dynamic> nodes;
  const TraceMapWidget({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Current pattern', nodes['pattern']),
      ('Underlying emotion', nodes['emotion']),
      ('Adaptation', nodes['adaptation']),
      ('Origin', nodes['origin']),
    ];
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(steps[i].$1.toUpperCase(),
                  style: TextStyle(fontSize: 11, letterSpacing: 0.5, color: color.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(steps[i].$2 ?? ''),
            ]),
          ),
          if (i < steps.length - 1)
            Icon(Icons.arrow_downward, color: color.primary, size: 20),
        ],
      ],
    );
  }
}
