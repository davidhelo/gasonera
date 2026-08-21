class InitialMapConfig {
  final double latitude;
  final double longitude;
  final double zoom;

  const InitialMapConfig({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });
}

const initialMapConfig = InitialMapConfig(
  latitude: 19.4326,
  longitude: -99.1332,
  zoom: 5.0,
);