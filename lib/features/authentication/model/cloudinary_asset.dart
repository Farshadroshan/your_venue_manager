class CloudinaryAsset {
  final String secureUrl;
  final String publicId;
  final String resourceType;
  final String originalFilename;

  const CloudinaryAsset({
    required this.secureUrl,
    required this.publicId,
    required this.resourceType,
    required this.originalFilename,
  });
}