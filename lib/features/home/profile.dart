// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/core/helper/avatar.dart';
import 'package:trauma/core/helper/navigator.dart';
import 'package:trauma/features/auth/login_screen.dart';
import '../../core/auth_service.dart';
import 'package:provider/provider.dart';

// import 'avatar_with_fallback.dart'; // if you put the helper in its own file

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Placeholder data — swap these for real values later.
  static const String _name = 'Jane Doe';
  static const String _email = 'jane.doe@example.com';
  static const String? _photoUrl = null; // null → uses asset fallback

  @override
  Widget build(BuildContext context) {
        final auth = context.read<AuthService>();

    return Container(
      decoration: BoxDecoration(gradient: appBgGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Profile'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: AvatarWithFallback(
                    imageUrl: _photoUrl,
                    radius: 56,
                    fallbackAsset: 'images/niyu.jpg',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 32),

                _ProfileCard(
                  children: [
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        // TODO: navigate to edit profile
                      },
                    ),
                    _ProfileTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        // TODO: navigate to change password
                      },
                    ),
                    _ProfileTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _ProfileCard(
                  children: [
                    _ProfileTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: ()async {
                    // TODO: call auth.signOut()
                    await auth.signOut();
                    changeScreenReplacement(context, LoginScreen());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
    );
  }
}