import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add Provider package
import 'pages/enter_coordinates_page.dart'; // Import the Enter Coordinates Page
import 'pages/area_computation_page.dart'; // Import the Area Computation Page
import 'pages/bearing_distance_page.dart'; // Import the Bearing and Distance Page
import 'pages/bearing_distance_from_coord_page.dart'; // Import the new B&D From Coord Page
import 'pages/beacon_index_page.dart'; // Import the Beacon Index Page
import 'pages/plan_data_page.dart'; // Import the Plan Data Page
import 'models/coordinate.dart'; // Import the Coordinate model
import 'package:provider/provider.dart'; // Add Provider package
import 'providers/theme_provider.dart'; // Import ThemeProvider
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Wrap the app with ThemeProvider
      child: ITAComputationsApp(),
    ),
  );
}

class ITAComputationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return MaterialApp(
      title: 'ITA Computations',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(), // Apply theme
      home: HomePage(), // Start with the HomePage
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Coordinate> _savedCoordinates = [];
  String _selectedUnit = 'Meters';

  // Use a GlobalKey to preserve the state of the EnterCoordinatesPage
  final GlobalKey<EnterCoordinatesPageState> _enterCoordinatesPageKey =
      GlobalKey<EnterCoordinatesPageState>();

  // List of pages to display based on the selected index
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize pages with the saved coordinates and selected unit
    _updatePages();
  }

  void _updatePages() {
    _pages = [
      EnterCoordinatesPage(
        key: _enterCoordinatesPageKey, // Pass the GlobalKey
        coordinates: _savedCoordinates,
        selectedUnit: _selectedUnit,
        onSave: _onSaveCoordinates,
      ),
      AreaComputationPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
      BearingDistancePage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
      BearingDistanceFromCoordPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit), // Add the new page
      BeaconIndexPage(
        coordinates: _savedCoordinates.map((coord) => {
          'Beacon': coord.beacon,
          'X': coord.x,
          'Y': coord.y,
        }).toList(), // Convert to List<Map<String, dynamic>>
      ),
      PlanDataPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
    ];
  }

  void _onSaveCoordinates(List<Coordinate> coordinates, String unit) {
    setState(() {
      _savedCoordinates = coordinates;
      _selectedUnit = unit;
      // Update the pages with the new data
      _updatePages();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('ITA Computations'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                themeProvider.toggleTheme(!themeProvider.isDarkMode); // Toggle theme
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'theme',
                child: Text(themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode'),
              ),
            ],
          ),
        ],
      ),
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : Container(), // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Enter Coordinates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Area Computation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route),
            label: 'Bearing & Distance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route),
            label: 'B&D From Coord', // Add the new page to the navigation bar
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Beacon Index',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Plan Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ThemeProvider Class for Dark/Light Theme Management
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}