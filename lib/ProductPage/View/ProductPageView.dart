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
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kacang Tanah",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Rp. 20.000", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                                textAlign: TextAlign.right,)
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Kacang tanah adalah tanaman yang menghasilkan biji-bijian yang kaya akan protein dan lemak sehat. Kacang ini sering digunakan dalam berbagai masakan dan camilan. Kacang tanah juga dikenal sebagai sumber energi yang baik dan mengandung berbagai nutrisi penting seperti vitamin E, magnesium, dan folat. Kacang tanah dapat dimakan mentah, direbus, atau digoreng, dan sering digunakan dalam pembuatan selai kacang. Kacang tanah juga memiliki manfaat kesehatan, termasuk meningkatkan kesehatan jantung, mengurangi risiko diabetes tipe 2, dan mendukung kesehatan otak. Namun, penting untuk mengonsumsinya dengan bijak karena kacang tanah juga mengandung kalori yang tinggi.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                         SizedBox(height: 20),
                         Row(
                           children: [
                             CircleAvatar(
                              backgroundImage: NetworkImage('https://instagram.fcgk30-1.fna.fbcdn.net/v/t51.29350-15/364993387_1032284108101815_2803375922758780302_n.webp?stp=dst-jpg_e35_tt6&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjc1Nng3NTYuc2RyLmYyOTM1MC5kZWZhdWx0X2ltYWdlIn0&_nc_ht=instagram.fcgk30-1.fna.fbcdn.net&_nc_cat=103&_nc_oc=Q6cZ2QHAp8gCSk2lvY0vZBIQwP5_Cy4Gp6UTgIaADABsLMvdMiLgN9pkJrrh3PPc14BR_1M&_nc_ohc=nkYnVXGL3-MQ7kNvwG0NatV&_nc_gid=oloy2UKAeoq04awEZDtkHg&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzE2MTY1MjY1MzMwODgxODA0Nw%3D%3D.3-ccb7-5&oh=00_AfRK6efud9VjMz3jRN4tYq1_aESIHfxMo_fCge401oYP1g&oe=6883B7BB&_nc_sid=10d13b'),
                              radius: 50,
                             ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Prayatna Ardi Wibisono",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Petani Kacang Tanah",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],)
                           ],
                         ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Action for Buy Now button
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Beli Sekarang", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Action for Add to Cart button
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Icon(Icons.shopping_cart, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                  ),
                ),
              ),
            ]
      ),
    )
      )
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

