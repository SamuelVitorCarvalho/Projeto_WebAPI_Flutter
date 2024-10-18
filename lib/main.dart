import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/journal.dart';
import 'screens/add_journal_screen/add_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'services/journal_service.dart';

void main() {
  runApp(const MyApp());

  JournalService service = JournalService();
  // service.register(Journal.empty());
  // service.getAll();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 5,
            shadowColor: Colors.grey,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: GoogleFonts.bitterTextTheme()),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: "login",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => LoginScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'add-journal') {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["is_editing"];

          return MaterialPageRoute(builder: (context) {
            return AddJournalScreen(journal: journal, isEdit: isEditing,);
          });
        }
        return null;
      },
    );
  }
}
