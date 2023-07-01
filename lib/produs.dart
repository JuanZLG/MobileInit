import 'package:flutter/material.dart';
import 'helpercompras.dart';
import 'inicio.dart';
import 'comprass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Prod(),
      debugShowCheckedModeBanner: false,
      routes: {
        // '/login': (context) => LoginScreen(),
        // '/registration': (context) => RegistrationScreen(),
        // '/emailVerification': (context) => EmailVerificationScreen(userEmail: userEmail),
      },
    );
  }
}

class Prod extends StatefulWidget {
  const Prod({Key? key}) : super(key: key);

  @override
  State<Prod> createState() => _ProdState();
}

class _ProdState extends State<Prod> {
  List<Map<String, dynamic>> _listaproductos = [];

  bool _isLoading = true;

  void _refreshProductos() async {
    final data = await SQLHelper.getProducts();
    setState(() {
      _listaproductos = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshProductos();
  
  }

  final TextEditingController _nombreController =
      TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _categoriaController= TextEditingController();
  final TextEditingController _saborController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingProducto =
          _listaproductos.firstWhere((element) => element['id'] == id);
      _nombreController.text = existingProducto['nombre'];
      _marcaController.text = existingProducto['marca'];
      _categoriaController.text = existingProducto['categoria'];
      _saborController.text = existingProducto['sabor'];
      _precioController.text = existingProducto['precio'].toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/ironmage.webp',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nombreController,
                    decoration:
                        const InputDecoration(hintText: 'Nombre del Producto'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _marcaController,
                    decoration:
                        const InputDecoration(hintText: 'Marca del Producto'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _categoriaController,
                    decoration:
                        const InputDecoration(hintText: 'Categoría del Producto'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _saborController,
                    decoration:
                        const InputDecoration(hintText: 'Sabor del Producto'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _precioController,
                    decoration:
                        const InputDecoration(hintText: 'Cantidad a Comprar'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _createProduct();
                      }

                      if (id != null) {
                        await _updateProduct(id);
                      }

                      // Clear the text fields
                      _nombreController.text = '';
                      _marcaController.text = '';
                      _categoriaController.text = '';
                      _saborController.text = '';
                      _precioController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Nuevo' : 'Actualizar'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Close the bottom sheet without saving
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            )));
  }

  Future<void> _createProduct() async {
    await SQLHelper.createProduct(
        _nombreController.text,
        _marcaController.text,
        _categoriaController.text,
        _saborController.text,
        int.parse(_precioController.text));
    _refreshProductos();
  }

  Future<void> _updateProduct(int id) async {
    await SQLHelper.updateProduct(
        id,
        _nombreController.text,
        _marcaController.text,
        _categoriaController.text,
        _saborController.text,
        int.parse(_precioController.text));
    _refreshProductos();
  }

  // Delete an item
  void _deleteProducts(int id) async {
    await SQLHelper.deleteProducts(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Registro eliminado con exito.'),
    ),
    );
    _refreshProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listaproductos.length,
              itemBuilder: (context, index) => Card(
                color: Colors.yellowAccent[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  leading: Icon(Icons.business),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height:3),
                    Text('Nombre:'),
                    Text('${_listaproductos[index]['nombre']}'),
                    SizedBox(height:2),
                    Text('Marca:'),
                    SizedBox(height:2),
                    Text('${_listaproductos[index]['marca']}'),
                    SizedBox(height: 2),
                    Text('Categoría:'),
                    SizedBox(height:2),
                    Text('${_listaproductos[index]['categoria']}'),
                    SizedBox(height:2),
                    Text('Sabor: '),
                    SizedBox(height: 2),
                    Text('${_listaproductos[index]['sabor']}'),
                    SizedBox(height:2),
                    Text('Precio:'),
                    SizedBox(height:2),
                    Text('${_listaproductos[index]['precio']}'),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(_listaproductos[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteProducts(_listaproductos[index]['id']),
                          ),
                        ],
                      ),
                    )
                  ]),
                ))),
                       
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
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
        },
      ),
    );
  }
}
