import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

class PasswordCodeScreen extends ConsumerWidget {
  PasswordCodeScreen({super.key});
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNotifier = ref.read(signInNotifierProvider.notifier);
    final signInState = ref.watch(signInNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter verification code'),
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
              color: Theme.of(context).colorScheme.primary,
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
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    controller: controllers[index],
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
                //! add functionality for verifying the code entered by the user.

                onPressed: () {
                  String verificationCode = controllers.map(
                    (controller) {
                      return controller.text;
                    },
                  ).join('');

                  print('Verification Code: $verificationCode');
                },
                child: const Text('Verify'),
              ),
            ),

            const SizedBox(height: 10),

            // Resend Code Button
            TextButton(
              onPressed: () async {
                signInNotifier.requestCode(signInState.email);
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
