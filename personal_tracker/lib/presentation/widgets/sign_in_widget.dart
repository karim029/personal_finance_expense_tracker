import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/provider/route_provider.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

/*
   todo: add ui handler for wrong email and password(user not found, password incorrect)
   todo: snackbar queue make sure 1 snackbar available before displaying another one 
  */
class LogInWidget extends ConsumerWidget {
  const LogInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNotifier = ref.read(signInNotifierProvider.notifier);
    final signInState = ref.read(signInNotifierProvider);
    // GlobalKey to manage the form's state
    final _formKey = GlobalKey<FormState>();

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
              ),
              Text(
                'Enter your credentials to log in',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        signInNotifier.updateEmail(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        labelText: 'Email',
                        icon: Icon(
                          Icons.mail_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be 8 characters minimum';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        signInNotifier.updatePassword(value);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        icon: Icon(
                          Icons.lock_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 40),
                ),
                onPressed: () async {
                  // Validate the form before proceeding
                  if (_formKey.currentState?.validate() ?? false) {
                    await signInNotifier.signInUser();
                    if (ref.read(signInNotifierProvider).isSignedIn) {
                      ref
                          .read(routeNotifierProvider.notifier)
                          .goTo(AppRoute.dashboard);
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            signInState.errorMessage ?? 'hi',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Log in'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot password?',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(routeNotifierProvider.notifier)
                            .goTo(AppRoute.register);
                      },
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
