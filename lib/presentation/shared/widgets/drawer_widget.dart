import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=3',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '03578 - Cristian Andres Afanador',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'caafanadord@ufpso.edu.co',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Gasto'),
            onTap: () {
              context.pop();
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Salir'),
            onTap: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
