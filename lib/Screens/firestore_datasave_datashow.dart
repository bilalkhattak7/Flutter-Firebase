import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSaveDataShow extends StatefulWidget {
  const FirestoreDataSaveDataShow({super.key});

  @override
  State<FirestoreDataSaveDataShow> createState() => _FirestoreDataSaveDataShowState();
}

class _FirestoreDataSaveDataShowState extends State<FirestoreDataSaveDataShow> {
  final textCtrl = TextEditingController();

  Future<void> saveData() async {
    if (textCtrl.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'text': textCtrl.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    textCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore')),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No data yet"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text(data['text'] ?? ''),
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
