import 'package:flutter/material.dart';

class ImageFullscreenView extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageFullscreenView({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
