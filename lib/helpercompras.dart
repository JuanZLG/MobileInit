import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static String tablePurchases = 'compras';
  static String tableProducts = 'productos';

  Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $tablePurchases(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        precio_unitario INTEGER,
        cantidad INTEGER,
        total INTEGER,
        id_producto INTEGER,
        FOREIGN KEY (id_producto) REFERENCES $tableProducts(id)
        )""");

    await database.execute('''
      CREATE TABLE $tableProducts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        marca TEXT,
        categoria TEXT,
        sabor TEXT,
        precio INTEGER
      )''');
  }

  Future<sql.Database> db() async {
    String data = await getDatabasesPath();
    print(data);
    return sql.openDatabase(
      path.join(await getDatabasesPath(), 'gestureducompra.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createCompra(Map<String, Object?> compraData) async {
    final db = await SQLHelper().db();

    final data = {
      'precio_unitario': compraData['precio_unitario'],
      'cantidad': compraData['cantidad'],
      'total': compraData['total'],
      'id_producto': compraData['id_producto'],
    };

    final id = await db.insert(
      'compras',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getCompras() async {
    final db = await SQLHelper().db();
    return db.query('compras', orderBy: "id");
  }

  static Future<Map<String, dynamic>?> getCompra(int id) async {
    final db = await SQLHelper().db();
    final result = await db.query(
      'compras',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateCompra(
      int id, Map<String, Object?> compraData) async {
    final db = await SQLHelper().db();

    final data = {
      'precio_unitario': compraData['precio_unitario'],
      'cantidad': compraData['cantidad'],
      'total': compraData['total'],
      'id_producto': compraData['id_producto'],
    };

    final result = await db.update(
      'compras',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteCompra(int id) async {
    final db = await SQLHelper().db();
    try {
      await db.delete("compras", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Ocurrió un error borrando la compra: $err");
    }
  }

  static Future<int> createProduct(String nombre, String marca,
      String categoria, String sabor, int precio) async {
    final db = await SQLHelper().db();

    final data = {
      'nombre': nombre,
      'marca': marca,
      'categoria': categoria,
      'sabor': sabor,
      'precio': precio
    };
    final id = await db.insert('productos', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await SQLHelper().db();
    return db.query('productos', orderBy: "id");
  }

  static Future<Map<String, dynamic>> getProduct(int idProd) async {
    final db = await SQLHelper().db();
    final result = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [idProd],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : {};
  }

  static Future<int> updateProduct(int id, String nombre, String marca,
      String categoria, String sabor, int precio) async {
    final db = await SQLHelper().db();

    final data = {
      'nombre': nombre,
      'marca': marca,
      'categoria': categoria,
      'sabor': sabor,
      'precio': precio
    };

    final result =
        await db.update('productos', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteProducts(int id) async {
    final db = await SQLHelper().db();
    try {
      await db.delete("productos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Ocurrió un error borrando el producto: $err");
    }
  }
}
