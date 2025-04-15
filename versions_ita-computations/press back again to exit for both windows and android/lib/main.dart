import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'pages/enter_coordinates_page.dart';
import 'pages/area_computation_page.dart';
import 'pages/bearing_distance_page.dart';
import 'pages/bearing_distance_from_coord_page.dart';
import 'pages/beacon_index_page.dart';
import 'pages/plan_data_page.dart';
import 'models/coordinate.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window_manager only on desktop platforms
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ITAComputationsApp(),
    ),
  );
}

class ITAComputationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'ITA Computations',
      theme: themeProvider.isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blueGrey,
                secondary: Colors.cyan[300]!,
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.cyan[700]!,
              ),
            ),
      home: HomePage(),
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

  final GlobalKey<EnterCoordinatesPageState> _enterCoordinatesPageKey =
      GlobalKey<EnterCoordinatesPageState>();

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _updatePages();
  }

  void _updatePages() {
    _pages = [
      EnterCoordinatesPage(
        key: _enterCoordinatesPageKey,
        coordinates: _savedCoordinates,
        selectedUnit: _selectedUnit,
        onSave: _onSaveCoordinates,
      ),
      AreaComputationPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
      BearingDistancePage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
      BearingDistanceFromCoordPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
      BeaconIndexPage(
        coordinates: _savedCoordinates.map((coord) => {
          'Beacon': coord.beacon,
          'X': coord.x,
          'Y': coord.y,
        }).toList(),
      ),
      PlanDataPage(coordinates: _savedCoordinates, selectedUnit: _selectedUnit),
    ];
  }

  void _onSaveCoordinates(List<Coordinate> coordinates, String unit) {
    setState(() {
      _savedCoordinates = coordinates;
      _selectedUnit = unit;
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ITA Computations'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                themeProvider.toggleTheme(!themeProvider.isDarkMode);
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
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : Container(),
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
            label: 'B&D From Coord',
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

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}