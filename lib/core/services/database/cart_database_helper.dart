import 'package:medicine_app/constant.dart';
import 'package:medicine_app/model/cart_product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabaseHelper {
  CartDatabaseHelper._();

  static final CartDatabaseHelper db = CartDatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'CartProduct.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableCartProduct (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnProductId TEXT NOT NULL,
    $columnStoreId TEXT NOT NULL,
    $columnStoreName TEXT NOT NULL,
    $columnName TEXT NOT NULL,
    $columnImage TEXT NOT NULL,
    $columnPrice TEXT NOT NULL,
    $columnQuantity REAL NOT NULL,
    $columnDescription TEXT,
    $columnBonus TEXT,
    $columnCurrency TEXT)
    ''');
  }

  insert(CartProductModel model) async {
    try {
      var dbClient = await database;
      await dbClient.insert(tableCartProduct, model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  Future<List<CartProductModel>> getAllProducts() async {
    try {
      var dbClient = await database;
      List<Map<String, dynamic>> maps =
          await dbClient.query('$tableCartProduct');

      List<CartProductModel> list = maps.isNotEmpty
          ? maps.map((product) => CartProductModel.fromJson(product)).toList()
          : [];

      return list;
    } catch (e) {
      print(e);
      return List<CartProductModel>();
    }
  }

  deleteSingleProduct(int id) async {
    var dbClient = await database;
    await dbClient
        .delete(tableCartProduct, where: '$columnId = ?', whereArgs: [id]);
  }

  deleteAllProduct() async {
    var dbClient = await database;
    await dbClient.delete('$tableCartProduct');
  }

  updateProduct(CartProductModel model) async {
    var dbClient = await database;
    await dbClient.update(tableCartProduct, model.toJson(),
        where: '$columnId = ?', whereArgs: [model.id]);
  }
}
