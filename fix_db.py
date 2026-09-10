import re

with open('lib/data/local/database_helper.dart', 'r') as f:
    content = f.read()

# Add imports
if 'import \'package:flutter/foundation.dart\';' not in content:
    content = content.replace('import \'package:sqflite/sqflite.dart\';', 
                              'import \'package:sqflite/sqflite.dart\';\nimport \'package:flutter/foundation.dart\';\nimport \'package:sqflite_common_ffi_web/sqflite_ffi_web.dart\';')

# Replace _initDB
pattern = r'Future<Database> _initDB\(String filePath\) async \{.*?\n  \}'
repl = """Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Use web implementation
      var factory = databaseFactoryFfiWeb;
      return await factory.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
    } else {
      // Use mobile/desktop implementation
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }"""
content = re.sub(pattern, repl, content, flags=re.DOTALL)

with open('lib/data/local/database_helper.dart', 'w') as f:
    f.write(content)
