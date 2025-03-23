import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Problem {
  final String id;
  final String userId;
  final String userName;
  final String description;
  final String imageUrl;
  final GeoPoint location;
  final String address;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;

  Problem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.address,
    this.likes = 0,
    this.likedBy = const [],
    required this.createdAt,
  });

  factory Problem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Problem(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      address: data['address'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'address': address,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Problem copyWith({
    String? id,
    String? userId,
    String? userName,
    String? description,
    String? imageUrl,
    GeoPoint? location,
    String? address,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
  }) {
    return Problem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      address: address ?? this.address,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 