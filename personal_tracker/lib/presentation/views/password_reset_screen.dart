import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordResetScreen extends ConsumerWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Icon(
              Icons.lock_reset_rounded,
              size: 150,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Informative Text
            const Text(
              'An email has been sent to your email address with instructions to reset your password. Enter the verification code below:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // Code Input Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add verification logic here
                },
                child: const Text('Verify'),
              ),
            ),

            const SizedBox(height: 10),

            // Resend Code Button
            TextButton(
              onPressed: () {
                // TODO: Add resend code logic here
              },
              child: Text(
                'Resend Code',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
