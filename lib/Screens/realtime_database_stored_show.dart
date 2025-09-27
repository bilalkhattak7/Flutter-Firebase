//RealTime Db Save data and show the data in the same screen
//CRUD Operations Create DB, Read DB, Update and Delete Db

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDBStoredAndShow extends StatefulWidget {
  const RealTimeDBStoredAndShow({super.key});

  @override
  State<RealTimeDBStoredAndShow> createState() =>
      _RealTimeDBStoredAndShowState();
}

class _RealTimeDBStoredAndShowState extends State<RealTimeDBStoredAndShow> {
  final textCtrl = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref("messages"); // "messages" node

  // CREATE
  Future<void> saveData() async {
    if (textCtrl.text.isEmpty) return;

    await dbRef.push().set({
      'text': textCtrl.text,
      'createdAt': DateTime.now().toIso8601String(),
    });

    textCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to Realtime DB ✅')),
    );
  }

  // UPDATE
  Future<void> updateData(String key, String newText) async {
    await dbRef.child(key).update({
      'text': newText,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // DELETE
  Future<void> deleteData(String key) async {
    await dbRef.child(key).remove();
  }

  // EDIT dialog
  void showEditDialog(String key, String oldText) {
    final editCtrl = TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Message"),
        content: TextField(
          controller: editCtrl,
          maxLines: 3,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              updateData(key, editCtrl.text);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Database')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              maxLines: 4,
              controller: textCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text here!",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveData,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),

            // READ + CRUD
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: dbRef.onValue, // listen to realtime updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No data yet"));
                  }

                  final data = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );

                  final entries = data.entries.toList().reversed.toList();

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final key = entries[index].key; // unique key
                      final value = Map<dynamic, dynamic>.from(entries[index].value);
                      final text = value['text'] ?? '';

                      return Card(
                        child: ListTile(
                          title: Text(text),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showEditDialog(key, text),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteData(key),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
