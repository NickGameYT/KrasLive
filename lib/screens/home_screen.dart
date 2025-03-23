import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'profile_screen.dart';
import 'problems_screen.dart';
import 'rating_screen.dart';
import 'car_wash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;
  
  // Начальные координаты Красноярска
  LatLng _center = const LatLng(56.0090, 92.8520);
  final Set<Marker> _markers = {};
  String currentAddress = 'ул. Урванцева, д. 14';

  @override
  void initState() {
    super.initState();
    _getLocationFromAddress(currentAddress);
  }

  Future<void> _getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress("$address, Красноярск, Россия");
      if (locations.isNotEmpty) {
        setState(() {
          _center = LatLng(locations.first.latitude, locations.first.longitude);
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('address_marker'),
              position: _center,
              infoWindow: InfoWindow(
                title: address,
                snippet: 'Отключение света: 27.03 08:00 - 16:00',
              ),
            ),
          );
        });
        
        // Перемещаем камеру к новой точке
        if (mapController != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _center, zoom: 16),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Ошибка геокодирования: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _centerMap();
  }

  Future<void> _centerMap() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mapController != null && _markers.isNotEmpty) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _center, zoom: 16),
        ),
      );
    }
  }

  void _openFullscreenMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A3780),
            foregroundColor: Colors.white,
            title: Text(currentAddress),
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16,
            ),
            markers: _markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
            compassEnabled: true,
            liteModeEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _center, zoom: 16),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 4) { // Профиль
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 3) { // Проблемы
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProblemsScreen()),
      );
    } else if (index == 2) { // Автомойка
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CarWashScreen()),
      );
    } else if (index == 1) { // Рейтинг
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RatingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с адресом
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3780),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    currentAddress,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Карточка с информацией об отключении
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3780),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    'ОТКЛЮЧЕНИЕ СВЕТА',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '27.03 08:00\n-\n27.03 16:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Текст с советом
            Container(
              margin: const EdgeInsets.all(16),
              child: const Text(
                'Отключили свет?\nПрогуляйтесь по набережной Енисея или устройте вечер настольных игр.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                ),
              ),
            ),

            // Карта
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16,
                      ),
                      markers: _markers,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      liteModeEnabled: false,
                    ),
                  ),
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF4A3780),
                      foregroundColor: Colors.white,
                      onPressed: _openFullscreenMap,
                      child: const Icon(Icons.fullscreen),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF4A3780),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Рейтинг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Автомойка',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_rounded),
            label: 'Проблемы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
} 