import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const CloseButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('CURRENCY', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: const Color(0xFF111111),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('NPR', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('USD', style: TextStyle(color: Color(0xFF333333)))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('PRIVACY', style: TextStyle(fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Hide balances by default'),
            value: false,
            onChanged: (val) {},
          ),
          const SizedBox(height: 24),
          const Text('DATA', style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Backup to Google Sheets'),
            trailing: const Icon(Icons.sync),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Export Data (CSV)'),
            trailing: const Icon(Icons.download),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          const Text('MANAGE', style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Income Sources / Accounts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Expense Categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Manage goals from Savings tab', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 24),
          const Text('ACCOUNT', style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
