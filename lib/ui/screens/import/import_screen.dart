import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Data'),
        leading: const CloseButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Select CSV / XLSX File'),
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            const Text('Column Mapping', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Mock column mapping dropdowns
            _buildMappingRow('Date', 'Select column'),
            _buildMappingRow('Description', 'Select column'),
            _buildMappingRow('Amount', 'Select column'),
            _buildMappingRow('Category', 'Select column'),
            
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: null, // Disabled until valid
              child: const Text('Confirm Import'),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildMappingRow(String field, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(field),
          DropdownButton<String>(
            hint: Text(hint),
            items: const [],
            onChanged: (val) {},
          )
        ],
      ),
    );
  }
}
