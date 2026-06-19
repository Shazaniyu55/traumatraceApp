import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trauma/features/widget/button.dart';
import 'package:trauma/features/widget/input.dart';
import '../../core/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  String? _error;
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() { _busy = true; _error = null; });
    try {
      await action();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Text('TraumaTrace',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Explore experiences, patterns, and stressors that may have shaped your wellbeing.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              InputFieldsWithSeparateIcon(headerText: "Email", hintText: "Email", svg: "email",
            
                  textController: _email,
                  hasHeader: true, onChange: null,

            ),
              //TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
               InputFieldPassword(
                  headerText: "Password",
                  svg: 'key',
                  hintText: '• • • • • • • •',
                  textController: _password, onChange: (){},
                ),
              // TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
              if (_error != null) Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
              const SizedBox(height: 20),
             BottomRectangularBtn(
  btnTitle: _register ? 'Create account' : 'Sign in',
  isLoading: _busy,
  loadingText: 'Please wait...',
  onTapFunc: _busy ? () {} : () => _run(
    () => _register
        ? auth.registerWithEmail(_email.text.trim(), _password.text)
        : auth.signInWithEmail(_email.text.trim(), _password.text),
  ),
),

              // FilledButton(
              //   onPressed: _busy ? null : () => _run(() => _register
              //       ? auth.registerWithEmail(_email.text.trim(), _password.text)
              //       : auth.signInWithEmail(_email.text.trim(), _password.text)),
              //   child: Text(_register ? 'Create account' : 'Sign in'),
              // ),
              TextButton(
                onPressed: () => setState(() => _register = !_register),
                child: Text(_register ? 'I already have an account' : 'Create an account'),
              ),
              const SizedBox(height: 8),
              const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('or')), Expanded(child: Divider())]),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _run(auth.signInWithGoogle),
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _run(auth.signInWithApple),
                icon: const Icon(Icons.apple),
                label: const Text('Continue with Apple'),
              ),
              if (_busy) const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
