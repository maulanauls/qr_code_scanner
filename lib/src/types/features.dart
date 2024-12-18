class SystemFeatures {
  SystemFeatures(this.hasFlash, this.hasBackCamera, this.hasFrontCamera);

  factory SystemFeatures.fromJson(Map<String, dynamic> features) =>
      SystemFeatures(
        features['hasFlash'] as bool? ?? false,
        features['hasBackCamera'] as bool? ?? false,
        features['hasFrontCamera'] as bool? ?? false,
      );

  final bool hasFlash;
  final bool hasFrontCamera;
  final bool hasBackCamera;
}
