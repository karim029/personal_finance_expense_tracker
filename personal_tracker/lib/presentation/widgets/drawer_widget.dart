import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/provider/registration_notifer.dart';
import 'package:personal_tracker/provider/route_provider.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

class AppDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signinState = ref.read(signInNotifierProvider.notifier);
    final registerState = ref.read(registrationNotifierProvider.notifier);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Hello ${ref.read(signInNotifierProvider).name}',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              // Handle Profile tap
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              // Handle Settings tap
              ref.read(routeNotifierProvider.notifier).goTo(AppRoute.settings);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              // Handle Logout tap
              ref.read(routeNotifierProvider.notifier).goTo(AppRoute.logIn);
              signinState.logoutUser();
              registerState.logoutUser();
            },
          ),
        ],
      ),
    );
  }
}
