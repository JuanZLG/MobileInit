import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ranfit/comprass.dart';
import 'produs.dart';
import 'iniciarsesion.dart';


class HomePage extends StatelessWidget {
  final List<String> images = [
    "assets/images/promocreakong.jpg",
    "assets/images/rock.webp",
    "assets/images/ironmage.webp",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/LogoBrutality2.jpg'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/gorille.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Brutality',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.no_drinks),
              title: const Text('Productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Prod()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: const Text('Compras'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComprasApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _swiper(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Más de 110 referencias!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Busca tu producto ideal',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      padding: const EdgeInsets.all(20.0),
                      childAspectRatio: 0.6,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '100.000',
                        ),
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '110.000',
                        ),
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '130.000',
                        ),
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '150.000',
                        ),
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '230.000',
                        ),
                        ProductCard(
                          image: Image.asset('assets/images/sgainer.webp'),
                          price: '180.000',
                        ),
                      ],
                    ),
                    const SizedBox(height: 80.0),
                  ],
                ),
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Términos y condiciones',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Derechos reservados',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        'TuiranFit © 2023',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Medellín, Colombia',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Compras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water),
            label: 'Productos',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComprasApp(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Prod(),
              ),
            );
        }
      
  }),
    );
  }

  Widget _swiper() {
    return Container(
      width: double.infinity,
      height: 250.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            images[index],
            fit: BoxFit.fill,
          );
        },
        autoplay: true,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Image image;
  final String price;

  ProductCard({
    Key? key,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: image,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '\$$price',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           ProductDetailScreen(product: Product())),
                // );
              },
              child: const Text('Comprar'),
            ),
          ),
        ],
      ),
    );
  }
}
