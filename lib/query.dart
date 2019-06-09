import 'package:mysql1/mysql1.dart';
import 'package:query_builder/database_interactor.dart';

class Query {

  String _table, _orderBy;
  List<String> _select, _groupBy;
  List<List<dynamic>> _where;
  List<Map<String, dynamic>> _insert;
  Map<String, dynamic> _update;
  bool _orderAsc, _isDistinct;

  Query() {
    _table = '';
    _orderBy = '';

    _select = [];
    _where = [];
    _groupBy = [];
    _insert = [];
    _update = {};

    _orderAsc = true;
    _isDistinct = false;
  }

  String getTable() => _table;
  String getOrderBy() => _orderBy;
  List<String> getSelect() => _select;
  List<List<dynamic>> getWhere() => _where;
  List<String> getGroupBy() => _groupBy;
  List<Map<String, dynamic>> getInsert() => _insert;
  Map<String, dynamic> getUpdate() => _update;
  bool isOrderAsc() => _orderAsc;
  bool isDistinct() => _isDistinct;

  void setTable(String table) {
    _table = table;
  }

  Query select(List<String> select) {
    _select.addAll(select);

    return this;
  }

  Query selectOne(String select) {
    _select.add(select);

    return this;
  }

  Query where(List<List<dynamic>> where) {
    where.forEach((List<dynamic> l) {
      if (l.length == 1)
        throw ArgumentError('Each where statement must contain at least two items! (column, value) or (column, comparison, value)');
    });
    _where.addAll(where);

    return this;
  }

  Query whereOne(List<dynamic> where) {
    if (where.length == 1)
      throw ArgumentError('Each where list must contain at least two items! [column, value] or [column, comparison, value]');

    _where.add(where);

    return this;
  }

  Query orderBy(String column, {String order}) {
    order = order.toLowerCase();
    if (order != null && order != 'asc' && order != 'desc') {
      throw ArgumentError('Order must be ASC or DESC');
    }

    _orderBy = column;
    _orderAsc = order == 'asc'; //true if ASC, false if DESC

    return this;
  }

  Query distinct() {
    _isDistinct = true;

    return this;
  }

  Query groupBy(List<String> groupBy) {
    _groupBy.addAll(groupBy);

    return this;
  }

  Query groupByOne(String groupBy) {
    _groupBy.add(groupBy);

    return this;
  }

  Future<Results> get() async {
    return await DatabaseInteractor.select(this);
  }

  Future<Results> insert(List<Map<String, dynamic>> rows) async {
    _insert = rows;

    return await DatabaseInteractor.insert(this);
  }

  Future<Results> update(Map<String, dynamic> rows) async {
    _update = rows;

    return await DatabaseInteractor.update(this);
  }

  Future<Results> delete() async {
    return await DatabaseInteractor.delete(this);
  }

}
