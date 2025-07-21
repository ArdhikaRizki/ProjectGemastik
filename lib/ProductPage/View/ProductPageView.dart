import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const Productpageview());
}

class Productpageview extends StatefulWidget {
  const Productpageview({super.key});

  @override
  State<Productpageview> createState() => _ProductpageviewState();
}

class _ProductpageviewState extends State<Productpageview> {
  int activeIndex = 0;
  final urlImage = [
    "https://www.pertanianku.com/wp-content/uploads/2021/04/Efek-Samping-Aflatoksin-pada-Kacang-Tanah-Berkualitas-Buruk.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0QQ7EtC4wqszok8OlBcp0hyxRG1Zgv9Tp9A&s",
    "https://id-test-11.slatic.net/p/d33a1356319979b77b2a365e21dc291f.jpg",
    "https://eborong.com.my/wp-content/uploads/2019/07/kacang_tanah_india_1.jpg"
  ];


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: urlImage.length,
                    itemBuilder: (context, index, realIndex) {
                      final url = urlImage[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                        child: Image.network(url, fit: BoxFit.cover, width: double.infinity,),

                      );
                    },
                    options: CarouselOptions(
                      height: 300.0,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20.0, // Jarak dari bawah
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(urlImage.length, (index) {
                        return _buildIndicator(index == activeIndex);
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Kacang Tanah',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kacang tanah adalah sumber protein nabati yang kaya akan nutrisi.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 12.0 : 8.0,
      height: isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

