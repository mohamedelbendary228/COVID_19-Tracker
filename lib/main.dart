import 'package:coronavirus_rest_api_tracker_app/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/api.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/api_service.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/data_cache_services.dart';
import 'package:coronavirus_rest_api_tracker_app/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
        ),
      ),
      child: MaterialApp(
        title: 'Coronavirus Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
      ),
    );
  }
}
