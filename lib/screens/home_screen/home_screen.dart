import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/logout.dart';
import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentDay = DateTime.now();
  int windowPage = 10;
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  int? userId;
  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  logout(context);
                },
                title: Text("Sair"),
                leading: Icon(Icons.logout),
              )
            ],
          ),
        ),
        body: (userId != null && userToken != null)
            ? ListView(
                controller: _listScrollController,
                children: generateListJournalCards(
                  refreshFunction: refresh,
                  windowPage: windowPage,
                  currentDay: currentDay,
                  database: database,
                  userId: userId!,
                  token: userToken!,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  void refresh() {
    SharedPreferences.getInstance().then(
      (prefs) {
        String? token = prefs.getString("accessToken");
        String? email = prefs.getString("email");
        int? id = prefs.getInt("id");

        if (token != null && email != null && id != null) {
          setState(() {
            userId = id;
            userToken = token;
          });

          service
              .getAll(id: id.toString(), token: token)
              .then((List<Journal> listJournal) {
            setState(() {
              database = {};

              for (Journal journal in listJournal) {
                database[journal.id] = journal;
              }
            });
          });
        } else {
          Navigator.pushReplacementNamed(context, "login");
        }
      },
    ).catchError(
      (error) {
        logout(context);
      },
      test: (error) => error is TokenNotValidException,
    ).catchError((error) {
      var innerError = error as HttpException;
      showExceptionDialog(context, content: innerError.message);
    }, test: (error) => error is HttpException);
  }
}
