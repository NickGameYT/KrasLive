import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_wash.dart';

class CarWashScreen extends StatefulWidget {
  const CarWashScreen({super.key});

  @override
  State<CarWashScreen> createState() => _CarWashScreenState();
}

class _CarWashScreenState extends State<CarWashScreen> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Центр Красноярска
  final LatLng _krasnoyarskCenter = const LatLng(56.0184, 92.8672);
  
  // Список автомоек
  final List<CarWash> carWashes = [
    const CarWash(
      id: '1',
      name: 'Автомойка',
      location: LatLng(56.0252, 92.8930), // ул. Степана Разина
      rating: 4.0,
      minPrice: 400,
      status: CarWashStatus.busy,
      address: 'ул. Степана Разина, 45',
      phone: '+7 (391) 222-33-44',
    ),
    const CarWash(
      id: '2',
      name: 'Автомойка',
      location: LatLng(56.0088, 92.8715), // На Дубровинского
      rating: 4.3,
      minPrice: 250,
      status: CarWashStatus.moderate,
      address: 'ул. Дубровинского, 62',
      phone: '+7 (391) 222-55-66',
    ),
    const CarWash(
      id: '3',
      name: 'Мойка 24',
      location: LatLng(55.9970, 92.8970), // Район цирка
      rating: 4.2,
      minPrice: 350,
      status: CarWashStatus.busy,
      address: 'ул. 60 лет Октября, 90',
      phone: '+7 (391) 222-77-88',
    ),
    const CarWash(
      id: '4',
      name: 'Чистый кузов',
      location: LatLng(56.0350, 92.8520), // Северная часть
      rating: 4.5,
      minPrice: 350,
      status: CarWashStatus.free,
      address: 'ул. Взлётная, 5',
      phone: '+7 (391) 222-99-00',
    ),
    const CarWash(
      id: '5',
      name: 'Блеск',
      location: LatLng(56.0150, 92.9050), // Восточная часть
      rating: 4.7,
      minPrice: 500,
      status: CarWashStatus.free,
      address: 'ул. Калинина, 23',
      phone: '+7 (391) 222-11-22',
    ),
  ];

  Set<Marker> _getMarkers() {
    final Set<Marker> markers = {};
    
    for (final wash in carWashes) {
      // Фильтрация по поисковому запросу
      if (_searchQuery.isNotEmpty &&
          !wash.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !wash.address.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !wash.minPrice.toString().contains(_searchQuery)) {
        continue;
      }
      
      markers.add(
        Marker(
          markerId: MarkerId(wash.id),
          position: wash.location,
          icon: wash.markerIcon,
          infoWindow: InfoWindow(
            title: '${wash.name} ★ ${wash.rating}',
            snippet: 'Кузов: от ${wash.minPrice} ₽',
          ),
          onTap: () {
            _showCarWashDetails(wash);
          },
        ),
      );
    }
    
    return markers;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _showCarWashDetails(CarWash wash) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wash.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3780),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        ' ${wash.rating}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: wash.statusColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    wash.statusText,
                    style: TextStyle(
                      color: wash.statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Адрес: ${wash.address}'),
              const SizedBox(height: 8),
              Text('Телефон: ${wash.phone}'),
              const SizedBox(height: 8),
              Text(
                'Цена от: ${wash.minPrice} ₽',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Добавить функционал звонка
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Позвонить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3780),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Добавить функционал навигации
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Маршрут'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3780),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3780),
        foregroundColor: Colors.white,
        title: const Text('АВТОМОЙКИ'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Поисковая строка
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск автомоек...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Карта
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _krasnoyarskCenter,
                zoom: 12,
              ),
              markers: _getMarkers(),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              liteModeEnabled: false,
            ),
          ),
          
          // Легенда
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatusIndicator(
                  color: Colors.green,
                  label: 'Свободно',
                ),
                _StatusIndicator(
                  color: Colors.yellow,
                  label: 'Средняя загруженность',
                ),
                _StatusIndicator(
                  color: Colors.red,
                  label: 'Высокая загруженность',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusIndicator({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 