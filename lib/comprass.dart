import 'package:flutter/material.dart';
import 'helpercompras.dart';
import 'iniciarsesion.dart';
import 'inicio.dart';
import 'produs.dart';

void main() {
  runApp(ComprasApp());
}

class ComprasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor negroPersonalizado = MaterialColor(
      0xFF000000, 
      <int, Color>{
        50: Color(0xFF000000), // Tonalidades más claras de negro
        100: Color(0xFF000000),
        200: Color(0xFF000000),
        300: Color(0xFF000000),
        400: Color(0xFF000000),
        500: Color(0xFF000000), // Color principal negro
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000), // Tonalidades más oscuras de negro
      },
    );

    return MaterialApp(
      title: 'Compras',
      theme: ThemeData(
        primarySwatch:
            negroPersonalizado, // Usar el MaterialColor personalizado
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownMenuItem<int>> _dropdownItems = [];
  List<Map<String, dynamic>> _compras = [];
  List<Map<String, dynamic>> _productos = [];
  int? compraId;
  bool _isLoading = false;


  late TextEditingController _precio_unitarioController;
  late TextEditingController _cantidadController;
  late TextEditingController _totalController;
  late TextEditingController _id_productoController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _precio_unitarioController = TextEditingController();
    _cantidadController = TextEditingController();
    _totalController = TextEditingController();
    _id_productoController = TextEditingController();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    final compras = await SQLHelper.getCompras();
    final productos = await SQLHelper.getProducts();

    setState(() {
      _compras = compras;
      _productos = productos;
      _isLoading = false;
    });

    _dropdownItems = _buildDropdownItems();
  }

  Future<void> _showForm(int? id, Map<dynamic, dynamic>? compra) async {
    final isEditing = id != 0;

    _precio_unitarioController.text = compra?['precio_unitario']?.toString() ?? '';
    _cantidadController.text = compra?['cantidad']?.toString() ?? '';
    _totalController.text = compra?['total']?.toString() ?? '';
    _id_productoController.text = compra?['id_producto']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(isEditing ? 'Editar Compra' : 'Crear compra'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<int>(
                  value: int.tryParse(_id_productoController.text),
                  items: _buildDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      _id_productoController.text = value.toString();
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Producto'),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona un producto';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa una cantidad';
                    }
                    final cantidad = int.tryParse(value);
                    if (cantidad == null || cantidad <= 0) {
                      return 'Por favor, ingresa una cantidad válida.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precio_unitarioController,
                  decoration: InputDecoration(labelText: 'Precio Unitario'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa un precio unitario';
                    }
                    final precio = int.tryParse(value);
                    if (precio == null || precio <= 0) {
                      return 'Por favor, ingresa un precio válido.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalController,
                  decoration: InputDecoration(labelText: 'Total'),
                  validator: (value) {
                    if (value!.isEmpty){
                      return 'Ingresa el total de la compra.';
                    }
                    final total = int.parse(value);
                    if(total == null || total <= 0){
                      return 'Ingresa un total.';
                    }
                    return null;
                    
                  },
                  enabled: true,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final compraData = {
                  'id': id,
                  'cantidad': int.parse(_cantidadController.text),
                  'precio_unitario':
                      int.tryParse(_precio_unitarioController.text),
                  'total': int.parse(_totalController.text),
                  'id_producto': int.parse(_id_productoController.text),
                };
                if (isEditing) {
                  // Map<String, dynamic>? existingCompra = await SQLHelper.getCompra(compraId!);
                  await SQLHelper.updateCompra(id!, compraData);
                  _refreshData();
                } else {
                  await SQLHelper.createCompra(compraData);
                  _refreshData();
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(isEditing ? 'Guardar Cambios' : 'Crear'),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return _productos.map((producto) {
      final int productId = producto['id'];
      final String productoNombre = producto['nombre'];
      final String dropdownItemText = '$productId - $productoNombre';

      return DropdownMenuItem<int>(
        value: productId,
        child: Text(dropdownItemText),
      );
    }).toList();
  }

  int _calculateTotal(){
    int cant = int.parse(_cantidadController.text);
    int precio = int.parse(_precio_unitarioController.text);
    int result = cant * precio;
    return result;
  }

  Future<void> _deleteCompra(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar compra'),
        content: const Text('¿Estás seguro de eliminar esta compra?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await SQLHelper.deleteCompra(id);
              Navigator.of(context).pop();
              _refreshData();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        centerTitle: true,
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
              leading: const Icon(Icons.shop),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _compras.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.business),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${_compras[index]['id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Producto:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                        future: SQLHelper.getProduct(
                          _compras[index]['id_producto']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final producto = snapshot.data;
                              if (producto != null) {
                                final int productId = producto['id'];
                                final String prodName = producto['nombre'];
                                final String providerText =
                                    '$productId - $prodName'.toString();

                                return Text(
                                  providerText,
                                  style: TextStyle(fontSize: 16),
                                );
                              } else {
                                return const Text('Producto no encontrado.');
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Cantidad:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_compras[index]['cantidad']}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Precio unitario:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_compras[index]['precio_unitario']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Precio total:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_compras[index]['total']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              _showForm(_compras[index]['id'], _compras[index]),
                          icon: const Icon(Icons.edit),
                          color: Colors.yellowAccent,
                        ),
                        IconButton(
                          onPressed: () => _deleteCompra(_compras[index]['id']),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(0, {}),
        child: const Icon(Icons.add),
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
