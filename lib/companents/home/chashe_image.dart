import 'package:disposable_cached_images/disposable_cached_images.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  final String keys;
  final String url;
  final BoxFit? fit;
  const CacheImage({super.key, required this.keys, required this.url, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return DisposableCachedImage.network(
      imageUrl: url,
      fit: fit,
      onLoading: (context, one, two) => const Center(child: CircularProgressIndicator(color: Colors.red)),
      progressBuilder: (context, progress) => Center(
        child: LinearProgressIndicator(value: progress),
      ),
      onError: (context, error, stackTrace, retryCall) => const Center(child: CircularProgressIndicator(color: Colors.red)),
      onImage: (context, imageWidget, height, width) => imageWidget
    );
  }
}