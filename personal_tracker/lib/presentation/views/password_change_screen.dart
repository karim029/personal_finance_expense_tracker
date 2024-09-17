import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

class PasswordChangeScreen extends ConsumerWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNotifier = ref.read(signInNotifierProvider.notifier);
    final signInState = ref.watch(signInNotifierProvider);

    final _formKey = GlobalKey<FormState>();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Icon(
              Icons.lock_rounded,
              size: 150,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),

            // Informative Text
            const Text(
              'Enter your new password below. Make sure to confirm it by entering it again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // Password Change Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // New Password Field
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter New Password',
                      labelText: 'New Password',
                      icon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      labelText: 'Confirm Password',
                      icon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Change Password Button
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Implement the password change logic here
                  final newPassword = _newPasswordController.text;

                  try {
                    // Call a method from the notifier to change the password
                    final result =
                        await signInNotifier.changePassword(newPassword);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password changed successfully',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to change password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.red,
                                ),
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'An error occurred. Please try again.',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
