import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDBStoredAndShow extends StatefulWidget {
  const RealTimeDBStoredAndShow({super.key});

  @override
  State<RealTimeDBStoredAndShow> createState() => _RealTimeDBStoredAndShowState();
}

class _RealTimeDBStoredAndShowState extends State<RealTimeDBStoredAndShow> {
  final textCtrl = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref("messages"); // "messages" node

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

            // Show saved messages
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: dbRef.onValue, // listen to realtime updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No data yet"));
                  }

                  final data = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );

                  final messages = data.values.map((e) => e['text'].toString()).toList().reversed.toList();

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(messages[index]),
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
