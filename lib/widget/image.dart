import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String imageUrl, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) =>
        Container(color: Colors.grey[200]),
    errorWidget: (BuildContext context, String url, dynamic error) =>
        const Icon(Icons.error),
  );
}
