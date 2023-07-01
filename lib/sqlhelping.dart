import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static final SQLHelper instance = SQLHelper._privateConstructor();

  static Database? _database;

  SQLHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, 'tuiranfitmb.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombres TEXT,
        apellidos TEXT,
        documento TEXT,
        direccion TEXT,
        correo TEXT,
        telefono TEXT,
        contrasena TEXT,
        verificationCode TEXT
      )
    ''');

    // await db.execute('''
    //   CREATE TABLE $tableProducts (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     nombre TEXT,
    //     categoria TEXT,
    //     marca TEXT,
    //     precioUnitario REAL,
    //     cantidad INTEGER,
    //     sabor TEXT,
    //     tamano TEXT
    //   )
    // ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, user);
  }

  Future<bool> checkUser(String correo, String contrasena) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Usuario no encontrado.');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    Database db = await instance.database;
    await db.update(
      tableUsers,
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    Database db = await instance.database;
    return await db.insert(tableProducts, product);
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(tableProducts);
    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> deleteProduct(int id) async {
    Database db = await instance.database;
    await db.delete(
      tableProducts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Future<int> createCompra(Map<String, dynamic> purchase) async {
  //   Database db = await instance.database;
  //   return await db.insert(tablePurchases, purchase);
  // }

  // Future<List<Purchase>> getAllPurchases() async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> result = await db.query(tablePurchases);
  //   return result.map((e) => Purchase.fromMap(e)).toList();
  // }

  // Future<Map<String, dynamic>> getPurchase(int id_compra) async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> result = await db.query(
  //     tablePurchases,
  //     where: 'id = ?',
  //     whereArgs: [id_compra],
  //   );
  //   if (result.isNotEmpty) {
  //     return result.first;
  //   } else {
  //     throw Exception('Usuario no encontrado.');
  //   }
  // }


Future<void> updatePurchase(int userId, Map<String, dynamic> userData) async {
    Database db = await instance.database;
    await db.update(
      tableUsers,
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  

  // Delete
  Future<int> deletePurchase(int id) async {
    Database db = await instance.database;
    return await db.delete(
      '',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
class Purchase {
  final int id;
  final String nombreproducto;
  final int precio_unitario;
  final int cantidad;
  final int total;
  final int id_producto;

Purchase({
  required this.id,
  required this.nombreproducto,
  required this.precio_unitario,
  required this.cantidad,
  required this.total,
  required this.id_producto,

});

Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreproducto': nombreproducto,
      'precio_unitario': precio_unitario,
      'cantidad': cantidad,
      'total': total,
      'id_producto': id_producto,
    };
}

factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      nombreproducto: map['nombreproducto'],
      precio_unitario: map['precio_unitario'],
      cantidad: map['cantidad'],
      total: map['total'],
      id_producto: map['id_producto'],
    );
  }

}


class Product {
  final int id;
  final String nombre;
  final String categoria;
  final String marca;
  final String sabor;
  final double precioUnitario;
  final int cantidad;

  Product({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.marca,
    required this.sabor,
    required this.precioUnitario,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'marca': marca,
      'sabor': sabor,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nombre: map['nombre'],
      categoria: map['categoria'],
      marca: map['marca'],
      sabor: map['sabor'],
      precioUnitario: map['precioUnitario'],
      cantidad: map['cantidad'],
    );
  }
}

const String tableUsers = 'users';
const String tableProducts = 'products';
const String tablePurchases = 'purchase';
