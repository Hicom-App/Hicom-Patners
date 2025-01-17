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
        onLoading: (context, one, two) => Image.asset('assets/images/logo_back.png', fit: BoxFit.cover),
        progressBuilder: (context, progress) => Image.asset('assets/images/logo_back.png', fit: BoxFit.cover),
        onError: (context, error, stackTrace, retryCall) => Center(child: Image.asset('assets/images/logo_back.png', fit: BoxFit.cover)),
        onImage: (context, imageWidget, height, width) => imageWidget
    );
  }
}