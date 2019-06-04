import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:query_builder/query.dart';

class DatabaseInteractor {

  static String _host, _username, _pass, _database;
  static int _port;

  static set host(String host) => _host = host;
  static set username(String username) => _username = username;
  static set pass(String pass) => _pass = pass;
  static set database(String database) => _database = database;
  static set port(int port) => _port = port;

  static Future<MySqlConnection> _getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: _host,
      port: _port == null ? 3306 : _port,
      user: _username,
      password: _pass,
      db: _database
    ));

    return conn;
  }

  static Future<Results> select(Query query) async {
    MySqlConnection conn = await _getConnection();

    String table = query.getTable();
    String selectStatement = query.getSelect().join(", ");
    String whereStatement = ' ';
    String orderByStatement = ' ';

    List<String> where = query.getWhere(),
      whereComparisons = query.getWhereComparisons();
    List<dynamic> whereValues = query.getWhereValues();

    if (where.length > 0) {
      whereStatement += 'WHERE ';
      for(int i = 0; i < where.length; i++) {
        whereStatement += where[i] + ' ' + whereComparisons[i] + ' ?';
        if (i+1 < where.length)
          whereStatement += ' AND ';
      }
    }

    String orderBy = query.getOrderBy();
    if (query.getOrderBy() != '') {
      orderByStatement += orderBy + ' ' + (query.isOrderAsc() ? 'ASC' : 'DESC');
    }

    String finalStatement = 'SELECT ' + selectStatement + ' FROM ' + table + whereStatement + orderByStatement;
    print(finalStatement);
    Results result = await conn.query(finalStatement, whereValues);

    conn.close();

    return result;
  }

  static Future<Results> insert(Query query) async {
    MySqlConnection conn = await _getConnection();

    String table = query.getTable();
    List<Map<String, dynamic>> insert = query.getInsert();

    var tableInfo = await conn.query('DESCRIBE ' + table);
    List<String> columnNames = [];
    tableInfo.forEach((Row row) {
      columnNames.add(row['Field']);
    });

    List<dynamic> data = [];

    String valueStatement = '';
    insert.forEach((Map<String, dynamic> row) {
      //Build data list
      columnNames.forEach((String col) {
        if (!row.keys.contains(col))
          data.add(null);
        else
          data.add(row[col]);
      });

      //Build valueStatement
      String cur = '(';
      for (int i = 0; i < columnNames.length; i++) {
        cur += '?';
        if (i+1 < columnNames.length)
          cur += ', ';
      }
      cur += '), ';
      valueStatement += cur;
    });
    valueStatement = valueStatement.substring(0, valueStatement.length - 2);

    String finalStatement = 'INSERT INTO ' + table + ' (' + columnNames.join(', ') + ') VALUES ' + valueStatement;
    Results results = await conn.query(finalStatement, data);

    conn.close();

    return results;
  }

  static Future<Results> update(Query query) async {
    MySqlConnection conn = await _getConnection();

    String table = query.getTable();
    List<dynamic> data = [];

    String setStatement = '', whereStatement = ' ';
    Map<String, dynamic> update = query.getUpdate();
    update.forEach((String col, dynamic val) {
      setStatement += col + ' = ?, ';
      data.add(val);
    });
    setStatement = setStatement.substring(0, setStatement.length - 2);

    List<String> where = query.getWhere(),
        whereComparisons = query.getWhereComparisons();
    List<dynamic> whereValues = query.getWhereValues();

    if (where.length > 0) {
      whereStatement += 'WHERE ';
      for(int i = 0; i < where.length; i++) {
        whereStatement += where[i] + ' ' + whereComparisons[i] + ' ?';
        if (i+1 < where.length)
          whereStatement += ' AND ';
      }
    }
    data.addAll(whereValues);

    String finalStatement = 'UPDATE ' + table + ' SET ' + setStatement + whereStatement;
    Results results = await conn.query(finalStatement, data);

    conn.close();
    return results;
  }

  static Future<Results> delete(Query query) async {
    MySqlConnection conn = await _getConnection();

    String table = query.getTable();

    String whereStatement = ' ';
    List<String> where = query.getWhere(),
        whereComparisons = query.getWhereComparisons();
    List<dynamic> whereValues = query.getWhereValues();

    if (where.length > 0) {
      whereStatement += 'WHERE ';
      for(int i = 0; i < where.length; i++) {
        whereStatement += where[i] + ' ' + whereComparisons[i] + ' ?';
        if (i+1 < where.length)
          whereStatement += ' AND ';
      }
    }

    String finalStatement = 'DELETE FROM ' + table + whereStatement;
    Results result = await conn.query(finalStatement, whereValues);

    conn.close();

    return result;
  }

}
