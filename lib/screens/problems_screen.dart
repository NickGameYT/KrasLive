import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/problem.dart';
import 'add_problem_screen.dart';

class ProblemCard extends StatelessWidget {
  final Problem problem;
  final VoidCallback onLike;
  final VoidCallback onLocationTap;

  const ProblemCard({
    super.key,
    required this.problem,
    required this.onLike,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  problem.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3780),
                  ),
                ),
                Text(
                  _formatDate(problem.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              problem.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Image.network(
              problem.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        problem.likedBy.contains('current_user_id')
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        color: const Color(0xFF4A3780),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        problem.likes.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A3780),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onLocationTap,
                  child: const Icon(Icons.location_on, color: Color(0xFF4A3780)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class ProblemsScreen extends StatefulWidget {
  const ProblemsScreen({super.key});

  @override
  State<ProblemsScreen> createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _toggleLike(Problem problem) async {
    final String userId = 'current_user_id'; // Замените на реальный ID пользователя
    final bool isLiked = problem.likedBy.contains(userId);
    
    try {
      await _firestore.collection('problems').doc(problem.id).update({
        'likes': FieldValue.increment(isLiked ? -1 : 1),
        'likedBy': isLiked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при обновлении лайка')),
        );
      }
    }
  }

  void _showOnMap(Problem problem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF4A3780),
            foregroundColor: Colors.white,
            title: Text(problem.address),
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                problem.location.latitude,
                problem.location.longitude,
              ),
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: MarkerId(problem.id),
                position: LatLng(
                  problem.location.latitude,
                  problem.location.longitude,
                ),
                infoWindow: InfoWindow(
                  title: problem.address,
                  snippet: problem.description,
                ),
              ),
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
            compassEnabled: true,
            liteModeEnabled: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3780),
        foregroundColor: Colors.white,
        title: const Text('КАРТА ПРОБЛЕМ'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('problems')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Произошла ошибка'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final problems = snapshot.data!.docs
              .map((doc) => Problem.fromFirestore(doc))
              .toList();

          if (problems.isEmpty) {
            return const Center(child: Text('Пока нет проблем'));
          }

          return ListView.builder(
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              return ProblemCard(
                problem: problem,
                onLike: () => _toggleLike(problem),
                onLocationTap: () => _showOnMap(problem),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A3780),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProblemScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 