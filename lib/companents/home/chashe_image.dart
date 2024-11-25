import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class CacheImage extends StatelessWidget {
  final String keys;
  final String url;
  final BoxFit? fit;
  const CacheImage({super.key, required this.keys, required this.url, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {

    return CachedNetworkImage(
        filterQuality: FilterQuality.high,
        cacheKey: keys,
        imageUrl: url,
        placeholder: (context, url) => Image.asset('assets/images/logo_back.png', fit: BoxFit.cover),
        errorWidget: (context, url, error) {
          debugPrint('Xatolik: $url');
          DefaultCacheManager().removeFile(keys).then((_) {
            debugPrint('Cache cleared for key: avatar');
          }).catchError((e) {
            debugPrint('Error clearing cache for key avatar: $e');
          });
          return Image.asset('assets/images/logo_back.png', fit: BoxFit.cover);
        },
        fit: fit
    );
  }
}