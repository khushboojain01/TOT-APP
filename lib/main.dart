import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/screens/home_screen.dart';
import 'screens/saved_dogs_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DogProvider(),
      child: TOTApp(),
    ),
  );
}

class TOTApp extends StatelessWidget {
  const TOTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOT APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigationScreen(),
      debugShowCheckedModeBanner: false, 
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SavedDogsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Saved'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        
      ),
    );
  }
}