import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class CachedNetworkImageHelper {
  static void preloadCoverImages(List<String> imageUrls) {
    for (var url in imageUrls) {
      preloadCoverImage(url);
    }
  }

  static void preloadCoverImage(String imageUrl) {
    CachedNetworkImageProvider(imageUrl).resolve(const ImageConfiguration());
  }
}