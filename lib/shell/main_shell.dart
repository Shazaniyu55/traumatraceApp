import 'package:flutter/material.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/features/progress/journal_screen.dart';
import '../features/home/home_tab.dart';
import '../features/resources/resources_tab.dart';
import '../features/progress/progress_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Keep tabs alive when switching
  final _tabs = const [HomeTab(), ResourcesTab(), ProgressTab(), JournalScreen()];

  void _onNavTap(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's state alive (scroll position, loaded data, etc.)
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _BottomBar(currentIndex: _index, onTap: _onNavTap),
    );
  }
}

// ── Custom bottom nav ────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.menu_book_rounded,
                label: 'Resources',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _ReflectButton(onTap: () => onTap(0)), // centre button goes to Home/Reflect
              _NavItem(
                icon: Icons.timeline_rounded,
                label: 'Progress',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.note_add_outlined,
                label: 'Journal',
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? primaryColor : const Color(0xFFAAB0BD);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _ReflectButton extends StatelessWidget {
  const _ReflectButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -6),
        child: Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha(120),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.self_improvement_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}