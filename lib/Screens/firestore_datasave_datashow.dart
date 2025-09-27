//FireStore Save data and show the data in the same screen
//CRUD Operations Create DB, Read DB, Update and Delete Db


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSaveDataShow extends StatefulWidget {
  const FirestoreDataSaveDataShow({super.key});

  @override
  State<FirestoreDataSaveDataShow> createState() =>
      _FirestoreDataSaveDataShowState();
}

class _FirestoreDataSaveDataShowState
    extends State<FirestoreDataSaveDataShow> {
  final textCtrl = TextEditingController();

  // CREATE
  Future<void> saveData() async {
    if (textCtrl.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'text': textCtrl.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    textCtrl.clear();
  }

  // UPDATE
  Future<void> updateData(String docId, String newText) async {
    await FirebaseFirestore.instance.collection('messages').doc(docId).update({
      'text': newText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  Future<void> deleteData(String docId) async {
    await FirebaseFirestore.instance.collection('messages').doc(docId).delete();
  }

  // Dialog for editing
  void showEditDialog(String docId, String oldText) {
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
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              updateData(docId, editCtrl.text);
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

            // READ (with edit/delete options)
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
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text(data['text'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showEditDialog(
                                  doc.id,
                                  data['text'] ?? '',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteData(doc.id),
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
