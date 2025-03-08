import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zylentrix_assi/widgets/screens/home_screen.dart';
import 'package:zylentrix_assi/widgets/state_controller/controller.dart';

void main() => runApp(
      //Intgretion Provider State Management
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                ProviderStateController(), //this is a state controller
            child: const HomeScreen(),
          ),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      title: 'Zylentrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Fredoka",
      ),
      home: const HomeScreen(), //DashBoard Screen
    );
  }
}
