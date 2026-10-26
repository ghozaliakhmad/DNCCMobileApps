import 'package:flutter/material.dart';
import '../main.dart';

const _imageSurface = Color(0xFFF7F9F6);

class ProductImage extends StatefulWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.iconSize = 56,
  });

  final String imageUrl;
  final BoxFit fit;
  final double iconSize;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool triedWikimediaThumbnail = false;

  Uri? get _wikimediaThumbnail {
    final uri = Uri.tryParse(widget.imageUrl);
    if (uri == null ||
        uri.host != 'upload.wikimedia.org' ||
        !uri.path.contains('/thumb/')) {
      return null;
    }

    final originalPath = uri.path.replaceFirst('/thumb/', '/');
    final imagePathEnd = originalPath.lastIndexOf('/');
    if (imagePathEnd <= 0) return null;
    final originalImagePath = originalPath.substring(0, imagePathEnd);
    final imageName =
        originalImagePath.substring(originalImagePath.lastIndexOf('/') + 1);
    final thumbnailPath = '${uri.path.substring(0, uri.path.lastIndexOf('/'))}'
        '/960px-$imageName';

    return uri.replace(host: 'thumb.wikimedia.org', path: thumbnailPath);
  }

  @override
  void didUpdateWidget(covariant ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      triedWikimediaThumbnail = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackUrl = triedWikimediaThumbnail ? null : _wikimediaThumbnail;
    final imageUrl = fallbackUrl?.toString() ?? widget.imageUrl;

    return ColoredBox(
      color: _imageSurface,
      child: Image.network(
        imageUrl,
        cacheWidth: 900,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: green,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (fallbackUrl != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !triedWikimediaThumbnail) {
                setState(() => triedWikimediaThumbnail = true);
              }
            });
            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: green,
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return Center(
            child: Icon(
              Icons.eco_rounded,
              size: widget.iconSize,
              color: green,
            ),
          );
        },
      ),
    );
  }
}
