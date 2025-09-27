import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/firestore_datasave_datashow.dart';
import 'Screens/firestorefileupload.dart';
import 'Screens/realtime_database_stored_show.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: RealTimeDBStoredAndShow());
  }
}
