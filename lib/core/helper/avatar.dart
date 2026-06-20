import 'package:flutter/material.dart';

/// Circular avatar that shows a network image, falling back to an asset
/// if the network image fails to load (or the url is empty).
class AvatarWithFallback extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String fallbackAsset;

  const AvatarWithFallback({
    super.key,
    required this.imageUrl,
    this.radius = 40,
    this.fallbackAsset = 'images/profile_placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    Widget assetFallback() => Image.asset(
          fallbackAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? assetFallback()
            : Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => assetFallback(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
      ),
    );
  }
}