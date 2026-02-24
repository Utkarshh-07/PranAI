class Therapist {
  final String id;
  final String name;
  final String phone;
  final String specialization;
  final double distance; // in km
  final double rating;
  final int reviews;
  final List<String> languages;
  final bool emergencyAvailable;
  final String imagePath;
  
  Therapist({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialization,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.languages,
    required this.emergencyAvailable,
    required this.imagePath,
  });
}